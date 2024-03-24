// this is copy pasted from https://github.com/emberjs/ember.js/blob/60d2e0cddb353aea0d6e36a72fda971010d92355/packages/%40ember/-internals/glimmer/lib/helpers/unique-id.ts
// Unfortunately due to https://github.com/emberjs/ember.js/issues/20165 we cannot use the built-in version in template tags
function uniqueId() {
  // @ts-expect-error this one-liner abuses weird JavaScript semantics that
  // TypeScript (legitimately) doesn't like, but they're nonetheless valid and
  // specced.
  return ([3e7] + -1e3 + -4e3 + -2e3 + -1e11).replace(/[0-3]/g, a => (a * 4 ^ Math.random() * 16 >> (a & 2)).toString(16));
}

export { uniqueId };
//# sourceMappingURL=utils.js.map
