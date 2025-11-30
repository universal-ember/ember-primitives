import Component from "@glimmer/component";
export declare class RatingState extends Component<{
    Args: {
        max: number | undefined;
        value: number | undefined;
        readonly: boolean | undefined;
        name: string;
        onChange?: (value: number) => void;
    };
    Blocks: {
        default: [
            internalApi: {
                stars: number[];
                value: number;
                total: number;
                handleClick: (event: Event) => void;
                handleChange: (event: Event) => void;
                setRating: (num: number) => void;
            },
            publicApi: {
                value: number;
                total: number;
            }
        ];
    };
}> {
    _value: number;
    get value(): number;
    get stars(): number[];
    setRating: (value: number) => void;
    setFromString: (value: unknown) => void;
    /**
     * Click events are captured by
     * - radio changes (mouse and keyboard)
     *   - but only range clicks
     */
    handleClick: (event: Event) => void;
    /**
     * Only attached to a range element, if present.
     * Range elements don't fire click events on keyboard usage, like radios do
     */
    handleChange: (event: Event) => void;
}
//# sourceMappingURL=state.d.ts.map