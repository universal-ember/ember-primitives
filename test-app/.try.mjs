export default scenarios();

function scenarios() {
  return {
    scenarios: [
      emberSource("5.8.0"),
      emberSource("5.12.0"),
      emberSource("6.4.0"),
      emberSource("6.8.0"),
      emberSource("latest"),
      emberSource("beta"),
      emberSource("alpha"),
    ],
  };
}

function emberSource(version) {
  return {
    name: `ember @ ${version}`,
    npm: {
      devDependencies: {
        "ember-source": `npm:ember-source@${version}`,
      },
    },
  };
}
