import Component from "@glimmer/component";
import type { Newable } from "./type-utils";
import type Owner from "@ember/owner";
export declare class Provide<Data extends object> extends Component<{
    /**
     * The Element is not customizable
     * (and also sometimes doesn't exist (depending on the `@element` value))
     */
    Element: null;
    Args: {
        /**
         * What data do you want to provide to the DOM subtree?
         *
         * If this is a function or class, it will be instantiated and given an
         * owner + destroyable linkage via `createStore`
         */
        data: Data | (() => Data) | Newable<Data>;
        /**
         * Optionally, you may use string-based keys to reference the data in the Provide.
         *
         * This is not recommended though, because when using a class or other object-like structure,
         * the type in the `<Consume>` component can be derived from that class or object-like structure.
         * With string keys, the `<Consume>` type will be unknown.
         */
        key?: string;
        /**
         * Can be used to either customize the element tag ( defaults to div )
         * If set to `false`, we won't use an element for the Provider boundary.
         *
         * Setting this to `false` changes the DOM Node containing the Provider's data to be a text node -- which can be useful when certain CSS situations are needed.
         *
         * But setting to `false` has a hazard: it allows subsequent sibling subtrees to access adjacent providers.
         *
         * There is no way around caveat in library land, and in a framework implementation of context,
         * it can only be solved by having render-tree context implemented, and ignoring DOM
         *  (which then makes the only difference between DOM-Context and Context be whether or not
         *    the context punches through Portals)
         */
        element?: keyof HTMLElementTagNameMap | false | undefined;
    };
    Blocks: {
        /**
         * The content that this component will _provide_ data to the entire hierarchy.
         */
        default: [];
    };
}> {
    get data(): Data;
    element: Text | HTMLElement;
    constructor(owner: Owner, args: {
        data: Data | (() => Data) | Newable<Data>;
        key?: string;
    });
    get useElementProvider(): boolean;
}
type DataForKey<Key> = Key extends string ? unknown : Key extends Newable<infer T> ? T : Key extends () => infer T ? T : Key;
export declare class Consume<Key extends object | string> extends Component<{
    Args: {
        key: Key;
    };
    Blocks: {
        default: [
            context: {
                data: DataForKey<Key>;
            }
        ];
    };
}> {
    getData: () => DataForKey<Key>;
    element: Text;
    constructor(owner: Owner, args: {
        key: Key;
    });
    get context(): {
        readonly data: DataForKey<Key>;
    };
}
export {};
//# sourceMappingURL=dom-context.d.ts.map