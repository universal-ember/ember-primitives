// Type augmentation for ember-scoped-css <style scoped> support
declare global {
  interface HTMLStyleElementAttributes {
    scoped?: unknown;
  }
}

export {};
