import path from "node:path";
import assert from "node:assert";
import { createRequire } from "node:module";

import { readPackageUp } from "read-package-up";
import { packageUp } from "package-up";
import defaultTheme from "tailwindcss/defaultTheme.js";
import typography from "@tailwindcss/typography";

// tailwindcss is built incorrectly to allow named imports
const fontFamily = defaultTheme.fontFamily;

const require = createRequire(import.meta.url);

/**
 * Thanks, past self
 * https://github.com/CrowdStrike/ember-oss-docs/blob/main/ember-oss-docs/tailwind.cjs
 */
const files = "**/*.{js,ts,hbs,gjs,gts,html,md}";
const sourceEntries = "{app,src,public}";

export async function config(root, { packages } = {}) {
  const appManifestPath = await packageUp(root);
  const packageResult = await readPackageUp(root);
  const appRoot = path.dirname(appManifestPath);

  const appPackageJson = packageResult?.packageJson;

  assert(appPackageJson, `Could not find package.json for ${root}`);

  const contentPaths = [
    `${appRoot}/${sourceEntries}/${files}`,

    /**
     * Also check if addons/libraries contain any tailwind classes
     * that we need to include
     *
     * This may be overkill for the typical app,
     * but for our use case, documentation apps, it should be fine.
     * (The risk here is scanning too many files and potentially
     *   running out of files watchers (tho, this isn't a problem on linux haha))
     */
    ...Object.keys(appPackageJson.dependencies)
      .map((depName) => {
        if (packages) {
          if (!packages.includes(depName)) {
            return;
          }
        }
        const packagePath = path.dirname(require.resolve(depName, { paths: [appRoot] }));

        return `${packagePath}/${files}`;
      })
      .filter(Boolean),
  ];

  /** @type {import('tailwindcss').Config} */
  return {
    content: [...contentPaths],
    darkMode: "selector",
    theme: {
      extend: {
        maxWidth: {
          "8xl": "88rem",
        },
        fontFamily: {
          sans: ["InterVariable", ...fontFamily.sans],
          display: ["Helvetica, Arial, sans-serif"],
        },
      },
    },
    plugins: [typography],
  };
}
