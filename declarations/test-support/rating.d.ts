/**
 * Test utility for interacting with the
 * Rating component.
 *
 * Simulates user behavior and provides high level functions so you don't need to worry about the DOM.
 *
 * Actual elements are not exposed, as the elements are private API.
 * Even as you build a design system, the DOM should not be exposed to your consumers.
 */
export declare function rating(selector?: string): RatingPageObject;
declare class RatingPageObject {
    #private;
    constructor(root: string);
    get label(): string;
    get stars(): string;
    get starTexts(): string;
    get value(): number;
    get isReadonly(): boolean;
    select(stars: number): Promise<void>;
}
export {};
//# sourceMappingURL=rating.d.ts.map