/**
 * Object for managing the color scheme
 */
export declare const colorScheme: {
    /**
     * Set's the current color scheme to the passed value
     */
    update: (value: string) => void;
    on: {
        /**
         * register a function to be called when the color scheme changes.
         */
        update: (callback: (colorScheme: string) => void) => void;
    };
    off: {
        /**
         * unregister a function that would have been called when the color scheme changes.
         */
        update: (callback: (colorScheme: string) => void) => void;
    };
    /**
     * the current valuel of the "color scheme"
     */
    current: string | undefined;
};
/**
 * Synchronizes state of `colorScheme` with the users preferences as well as reconciles with previously set theme in local storage.
 *
 * This may only be called once per app.
 */
export declare function sync(): void;
/**
 * Helper methods to determining what the user's preferred color scheme is
 */
export declare const prefers: {
    dark: () => boolean;
    light: () => boolean;
    custom: (name: string) => boolean;
    none: () => boolean;
};
/**
 * Helper methods for working with the color scheme preference in local storage
 */
export declare const localPreference: {
    isSet: () => boolean;
    read: () => string | null;
    update: (value: string) => void;
    delete: () => void;
};
/**
 * For the given element, returns the `color-scheme` of that element.
 */
export declare function getColorScheme(element?: HTMLElement): string;
export declare function setColorScheme(element: HTMLElement, value: string): void;
export declare function setColorScheme(value: string): void;
/**
 * Removes the `color-scheme` from the given element
 */
export declare function removeColorScheme(element?: HTMLElement): void;
//# sourceMappingURL=color-scheme.d.ts.map