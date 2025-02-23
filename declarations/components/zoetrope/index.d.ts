import './styles.css';
import Component from '@glimmer/component';
import type { ScrollBehavior, Signature } from './types.ts';
export declare class Zoetrope extends Component<Signature> {
    scrollerElement: HTMLElement | null;
    currentlyScrolled: number;
    scrollWidth: number;
    offsetWidth: number;
    private setCSSVariables;
    scrollerWaiter: unknown;
    noScrollWaiter: () => void;
    private configureScroller;
    private tabListener;
    private scrollListener;
    get offset(): number;
    get gap(): number;
    get canScroll(): boolean;
    get cannotScrollLeft(): boolean;
    get cannotScrollRight(): boolean;
    get scrollBehavior(): ScrollBehavior;
    scrollLeft: () => void;
    scrollRight: () => void;
    private findOverflowingElement;
}
export default Zoetrope;
//# sourceMappingURL=index.d.ts.map