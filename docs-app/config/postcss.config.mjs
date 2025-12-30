import autoprefixer from "autoprefixer";
import postcssImport from "postcss-import";
import tailwind from "tailwindcss";
import twConfig from './tailwind.config.mjs';

const config = {
  plugins: [
    postcssImport(),
    tailwind(twConfig),
    autoprefixer(),
  ],
};

export default config;
