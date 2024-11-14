import postcssImport from "postcss-import";
import tailwind from "tailwindcss";
import autoprefixer from "autoprefixer";

const config = {
  plugins: [
    postcssImport(),
    tailwind((await import("./tailwind.config.mjs")).default),
    autoprefixer(),
  ],
};

export default config;
