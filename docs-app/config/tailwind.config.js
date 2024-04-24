const path = require('path');

const { fontFamily } = require('tailwindcss/defaultTheme');

const appRoot = path.join(__dirname, '../');

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [`${appRoot}/app/**/*.{js,ts,hbs,gjs,gts,html}`],
  darkMode: 'selector',
  theme: {
    extend: {
      maxWidth: {
        '8xl': '88rem',
      },
      fontFamily: {
        sans: ['InterVariable', ...fontFamily.sans],
        display: ['Lexend', { fontFeatureSettings: '"ss01"' }],
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
};
