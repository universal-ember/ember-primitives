import Helper from '@ember/component/helper';
import { assert } from '@ember/debug';
import { getOwner } from '@ember/owner';

class GetService extends Helper {
  compute(positional) {
    let owner = getOwner(this);
    assert(`Could not get owner.`, owner);
    return owner.lookup(`service:${positional[0]}`);
  }
}
const service = GetService;

export { GetService as default, service };
//# sourceMappingURL=service.js.map
