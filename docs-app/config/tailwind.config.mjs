import { join } from "node:path";
import { config as docsSupport } from "@universal-ember/docs-support/tailwind";

const appRoot = join(import.meta.dirname, "../");
const config = await docsSupport(appRoot, {
  packages: ["@universal-ember/docs-support"],
});

// console.log(config);

export default {
  ...config,
};
