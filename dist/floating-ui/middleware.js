function exposeMetadata() {
  return {
    name: 'metadata',
    fn: data => {
      // https://floating-ui.com/docs/middleware#always-return-an-object
      return {
        data
      };
    }
  };
}

export { exposeMetadata };
//# sourceMappingURL=middleware.js.map
