import Helper from '@ember/component/helper';
import type { Registry } from '@ember/service';
import type Service from '@ember/service';
export interface Signature<Key extends keyof Registry> {
    Args: {
        Positional: [Key];
    };
    Return: Registry[Key] & Service;
}
export default class GetService<Key extends keyof Registry> extends Helper<Signature<Key>> {
    compute(positional: [Key]): Registry[Key] & Service;
}
export declare const service: typeof GetService;
//# sourceMappingURL=service.d.ts.map