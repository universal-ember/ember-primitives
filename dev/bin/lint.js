#!/usr/bin/env node
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import chalk from 'chalk';
import { packageJson, project } from 'ember-apply';
import { execa, execaCommand } from 'execa';
import { globbySync } from 'globby';

const [, , command] = process.argv;
// process.cwd() is whatever pnpm decides to do
//
// For now, we use INIT_CWD, because we want to use
// whatever the User's CWD is, even if we are invoked via
// pnpm -w exec, which is "workspace root"
//
// Other options:
//  PNPM_SCRIPT_SRC_DIR
//  OLDPWD
const cwd = process.env['INIT_CWD'];

const root = await project.gitRoot();
const manifest = await packageJson.read(cwd);
const relative = path.relative(root, cwd);

if (process.env['DEBUG']) {
  console.debug(`${manifest.name} :: within ${relative}`);
}

async function run() {
  switch (command) {
    case 'prettier:fix':
      return execaCommand(
        `pnpm prettier -w . ` + `--cache --cache-strategy content`,
        { cwd, stdio: 'inherit' },
      );
    case 'prettier':
      return execaCommand(`pnpm prettier -c .`, { cwd, stdio: 'inherit' });
    case 'published-types':
      return lintPublishedTypes({ cwd });
    case 'js:fix':
      return execaCommand(
        `pnpm eslint . ` + `--fix --cache --cache-strategy content`,
        { cwd, stdio: 'inherit' },
      );
    case 'js':
      return execaCommand(`pnpm eslint .`, { cwd, stdio: 'inherit' });
    case 'hbs:fix':
      return execaCommand(
        `pnpm ember-template-lint . --fix --no-error-on-unmatched-pattern`,
        { cwd, stdio: 'inherit' },
      );
    case 'hbs':
      return execaCommand(
        `pnpm ember-template-lint . --no-error-on-unmatched-pattern`,
        { cwd, stdio: 'inherit' },
      );
    case 'fix':
      return turbo('_:lint:fix');
    default:
      return turbo('_:lint');
  }
}

/**
  * attw does not support wildcard entrypoints
  */
async function lintPublishedTypes({ cwd }) {
  let manifest = await packageJson.read(cwd);
  let name = manifest.name;

  let entrypoints = [];

  for (let [entryGlob, mapping] of Object.entries(manifest['exports'])) {
    if (!entryGlob.includes('*')) {
      let entry = path.join(name, entryGlob);

      entrypoints.push(entry);
      continue;
    }

    const files = globbySync(mapping.types.replace('*', '**/*'), {cwd});

    // Map the files to full module paths
    const mappedFiles = files.map(file => {
      // Now that we found files, we need to map them _back_ to entrypoints.
      // Based on the entryGlob, we need to remove the path leading up until the '*',
      let toRemove = mapping.types.split('*')[0];
      let moduleName = file.split(toRemove)[1];

      // we need to chop off the extension IFF the mapping.types includes it
      if (mapping.types.endsWith('.d.ts')) {
        moduleName = moduleName.replace('.d.ts', '');
      }

      return moduleName;
    });

    entrypoints.push(...mappedFiles);
  }

  entrypoints = entrypoints
    // Remove stuff we are going to exclude
    .filter(entry => !entry.endsWith('addon-main'))
    // Remove index files
    .filter(entry => !entry.endsWith('index'));

  let args = [
    'attw', '--pack',
    // This does not provide types
    '--exclude-entrypoints', 'addon-main',
    // We turn this one off because we don't care about CJS consumers
    '--ignore-rules', 'cjs-resolves-to-esm',
    // Wildcard is not official supported
    '--ignore-rules', 'wildcard',
    // publint will handle resolving
    '--ignore-rules', 'internal-resolution-error',
    '--include-entrypoints', ...entrypoints
  ];

  console.info(chalk.blueBright('Running:\n', args.join(' ')));

  await execa('pnpm', args, {
    cwd,
    stdio: 'inherit',
  });
}

function turbo(cmd) {
  let args = [
    'turbo',
    '--color',
    '--no-update-notifier',
    '--output-logs',
    'errors-only',
    cmd,
  ];

  console.info(chalk.blueBright('Running:\n', args.join(' ')));

  return execa('pnpm', args, { stdio: 'inherit', env: { FORCE_COLOR: '1' } });
}

async function dumpErrorLog(e) {
  function generateRandomName() {
    const timestamp = new Date().getTime();
    const random = Math.floor(Math.random() * 1000);

    return `file_${timestamp}_${random}.log`;
  }

  try {
    const randomName = await generateRandomName();
    const tmpDir = os.tmpdir();
    const filePath = path.join(tmpDir, randomName);

    const content =
      `\n` +
      new Date() +
      '\n' +
      e.message +
      '\n\n' +
      '====================================================' +
      '\n\n' +
      e.stack;

    await fs.writeFile(filePath, content);

    console.error(chalk.red('Error log at ', filePath));
  } catch (err) {
    console.error(chalk.red('Error creating file:', err));
  }
}

try {
  await run();
} catch (e) {
  await dumpErrorLog(e);
  // eslint-disable-next-line n/no-process-exit
  process.exit(1);
}
