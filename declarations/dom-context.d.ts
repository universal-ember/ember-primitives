import Component from "@glimmer/component";
import type { Newable } from "./type-utils";
import type Owner from "@ember/owner";
export declare class Provide<Data extends object> extends Component<{
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
    };
    Blocks: {
        /**
         * The content that this component will _provide_ data to the entire hierarchy.
         */
        default: [];
    };
}> {
    get data(): Data;
    element: HTMLDivElement;
    constructor(owner: Owner, args: {
        data: Data | (() => Data) | Newable<Data>;
        key?: string;
    });
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
    element: HTMLDivElement;
    constructor(owner: Owner, args: {
        key: Key;
    });
    get context(): {
        readonly data: DataForKey<Key>;
    };
}
export {};
