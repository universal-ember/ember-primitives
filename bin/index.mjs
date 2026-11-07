#!/usr/bin/env node
/* eslint-disable n/no-process-exit */

import { spawn, spawnSync } from "node:child_process";
import { existsSync } from "node:fs";
import { glob, stat } from "node:fs/promises";
import { extname, isAbsolute, join, relative } from "node:path";
import { fileURLToPath } from "node:url";
import { parseArgs, styleText } from "node:util";

const repoURL = "https://github.com/universal-ember/ember-primitives.git";
const binName = "ember-primitives";
const repoPrefix = `ember-primitives/src/`;

async function findAvailableFiles() {
  const packageRoot = fileURLToPath(new URL("..", import.meta.url));
  const pattern = "./src/**/*";

  const matches = [];
  for await (const match of glob(pattern, { cwd: packageRoot })) {
    const rel = isAbsolute(match) ? relative(packageRoot, match) : match;
    matches.push(rel.replace(/\\/g, "/"));
  }

  // The built-in glob can include directories; filter to files.
  // Do this after collecting to keep behavior stable.
  const stats = await Promise.all(
    matches.map(async (p) => {
      try {
        const s = await stat(join(packageRoot, p));
        return s.isFile() ? p : null;
      } catch {
        return null;
      }
    }),
  );

  return stats.filter((p) => p !== null).map((x) => join("ember-primitives", x));
}

function printHelp() {
  console.log(`\
${binName}

Usage:
	${binName} emit <filepath> --output-folder <path> [--javascript] [--tag <tag>]

Description:
	"emit" is a thin wrapper around unlibrary (https://github.com/NullVoxPopuli/unlibrary)
	with defaults derived from this repository.

Examples:
	${binName} emit store.ts --output-folder ./src/primitives/
	${binName} emit ember-primitives/src/create-store.ts --output-folder ./src/primitives/ --javascript

Options:
	--output-folder, --out <path>   Where unlibrary should copy files (required)
	--tag <tag>                     Override the git tag (default: vMAJOR.MINOR from package version)
	--javascript                    Force JavaScript output when TS is encountered
	-h, --help                      Show help
`);
}

function fail(message) {
  console.error(message);
  console.error("");
  printHelp();
  process.exit(1);
}

function assertNodeVersion() {
  // unlibrary currently requires Node >= 24.12.0 (per its package.json engines).
  const major = Number(String(process.versions.node).split(".")[0]);
  if (Number.isFinite(major) && major < 24) {
    fail(
      `unlibrary requires Node >= 24.12.0, but you're running Node ${process.versions.node}.\n` +
        `Please upgrade Node (or run this in an environment that has Node 24+) and try again.`,
    );
  }
}

function hasCommand(cmd) {
  const result = spawnSync(cmd, ["--version"], { stdio: "ignore" });
  if (result.error && result.error.code === "ENOENT") return false;
  // Some tools return non-zero for --version in odd envs; if it spawned, we treat as present.
  return true;
}

function spawnWithInherit(cmd, args) {
  return new Promise((resolve, reject) => {
    const child = spawn(cmd, args, {
      stdio: "inherit",
      shell: false,
    });

    child.on("error", reject);
    child.on("exit", (code, signal) => {
      if (signal) {
        resolve(1);
      } else {
        resolve(code ?? 1);
      }
    });
  });
}

async function runUnlibrary(unlibraryArgs) {
  // Prefer GitHub source, then fall back to npm package.
  // We also prefer pnpm (this repo uses pnpm) and fall back to npx.
  const candidates = [];

  if (hasCommand("pnpm")) {
    candidates.push(["pnpm", ["dlx", "unlibrary@latest", ...unlibraryArgs]]);
  }

  if (hasCommand("npx")) {
    candidates.push(["npx", ["-y", "unlibrary@latest", ...unlibraryArgs]]);
  }

  if (candidates.length === 0) {
    fail("Could not find pnpm or npx to run unlibrary. Please install pnpm (recommended) or npm.");
  }

  console.log(`
  Running:

    ${styleText("cyan", "unlibrary")} ${unlibraryArgs.map((arg) => (arg.startsWith("--") ? styleText("gray", arg) : styleText("yellow", arg))).join(" ")}
  `);

  let lastExitCode = 1;
  let lastError;

  for (const [cmd, args] of candidates) {
    try {
      lastExitCode = await spawnWithInherit(cmd, args);
      if (lastExitCode === 0) return 0;
    } catch (e) {
      lastError = e;
    }
  }

  if (lastError) throw lastError;
  return lastExitCode;
}

async function check() {
  const parsed = parseArgs({
    args: process.argv.slice(2),
    allowPositionals: true,
    strict: false,
    options: {
      help: { type: "boolean", short: "h" },
    },
  });

  if (parsed.values.help) {
    printHelp();
    process.exit(0);
  }

  const [command, ...positionals] = parsed.positionals;

  if (!command) {
    printHelp();
    process.exit(0);
  }
  if (command !== "emit") {
    fail(`Unknown command: ${command}`);
  }

  assertNodeVersion();

  const errors = [];

  const filepathInput = positionals[0];
  if (!filepathInput) {
    errors.push("Missing required argument: <filepath>");
  }

  if (errors.length > 0) {
    console.error("Errors:");
    errors.forEach((error) => console.error(`  - ${error}`));
    console.error("");
    printHelp();
    process.exit(1);
  }

  return { filepathInput };
}

async function findFile(filepathInput) {
  const availableFiles = await findAvailableFiles();

  let candidates = availableFiles.filter((available) => {
    let trimmed = available.replace(repoPrefix, "");

    if (trimmed === filepathInput) {
      return true;
    }

    let ext = extname(trimmed);
    let extensionless = trimmed.replace(new RegExp(RegExp.escape(ext) + "$"), "");

    if (extensionless === filepathInput) {
      return true;
    }
  });

  if (candidates.length > 1) {
    fail(`Too many candidate files found: ${candidates}. Please specify one only`);
  }

  if (candidates === 0) {
    let potentials = availableFiles
      .map((x) => x.replace(repoPrefix, ""))
      .filter((x) => x.includes(filepathInput));

    fail(
      `Not file matches found for ${filepathInput}. Did you mean one of ${potentials ?? availableFiles}`,
    );
  }

  const filepath = candidates[0];

  return { filepath };
}

function findOutput() {
  let cwd = process.cwd();
  let src = join(cwd, "src");
  let app = join(cwd, "app");

  if (existsSync(src)) return "src/primitives";
  if (existsSync(app)) return "app/primitives";

  fail(
    `Could not determine output folder automatically. Please specify --output-folder ./place-to/emit/files`,
  );
}

async function main() {
  const { filepathInput } = await check();
  const { filepath } = await findFile(filepathInput);

  // Get remaining args that weren't parsed by parseArgs
  const remainingArgs = process.argv.slice(2).filter((arg, index) => {
    // Skip the command itself
    if (index === 0) return false;
    // Skip positional filepath argument
    if (index === 1 && !arg.startsWith("-")) return false;
    // Skip known parsed options and their values
    if (arg === "--help" || arg === "-h") return false;
    return true;
  });

  const unlibraryArgs = [
    "--repo",
    repoURL,
    ...(remainingArgs.includes("--filepath") ? [] : ["--filepath", filepath]),
    ...(remainingArgs.includes("--output-folder") ? [] : ["--output-folder", findOutput()]),
    ...remainingArgs,
  ];

  const exitCode = await runUnlibrary(unlibraryArgs);
  process.exit(exitCode);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
