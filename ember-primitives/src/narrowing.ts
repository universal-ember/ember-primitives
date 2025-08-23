export function isString(x: unknown): x is string {
  return typeof x === 'string';
}

export function isElement(x: unknown): x is Element {
  return x instanceof Element;
}
