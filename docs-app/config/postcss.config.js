module.exports = {
  plugins: {
    // postcss-import causes a massive perf degredation in webpack
    //'postcss-import': {},
    tailwindcss: {
      config: 'config/tailwind.config.js',
    },
    autoprefixer: {},
  },
};
