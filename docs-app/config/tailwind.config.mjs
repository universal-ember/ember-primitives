import { join } from "node:path";
import { config } from "@universal-ember/docs-support/tailwind";

const appRoot = join(import.meta.dirname, "../");

const ourConfig = config(appRoot);
console.log({ ourConfig})
export default ourConfig;
