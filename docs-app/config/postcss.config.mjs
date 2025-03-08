import autoprefixer from "autoprefixer";
import postcssImport from "postcss-import";
import tailwind from "tailwindcss";

const config = {
  plugins: [
    postcssImport(),
    tailwind((await import("./tailwind.config.mjs")).default),
    autoprefixer(),
  ],
};

export default config;
