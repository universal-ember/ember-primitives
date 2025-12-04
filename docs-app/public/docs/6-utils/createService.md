# createService

This utility will create a service using a class definition similar to what is described in [RFC#502](https://github.com/emberjs/rfcs/pull/502) for explicit service injection -- no longer using strings. This allows module graphs to shake out services that aren't used until they are _needed_.


## Setup

```bash 
pnpm add ember-primitives
```

Introduced in [0.47.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.47.0-ember-primitives)


## Usage

```js
import { createService } from 'ember-primitives/service';

class MyState {
  // @services are allowed here
}

class Demo extends Component {
  // lazyily created upon access of `foo`
  get foo() {
    return createService(this, MyState);
  }

  // or eagrly created when `Demo` is created
  state = createService(this, MyState);
}
```

### With Arguments

```js
import { createService } from 'ember-primitives/service';

class MyState {
  constructor(/* .. */ ) { /* ... */ }
}

class Demo extends Component {
  get state() {
    return createService(this, () => new MyState(1, 2));
  }
}
```

### Accessing Services and handling cleanup 

Like with [`link`][reactiveweb-link], use of services and `registerDestructor` is valid:
```js
import { service } from '@ember/service';
import { createService } from 'ember-primitives/service';

class MyState {
  @service router;

  constructor(/* .. */) { 
    registerDestructor(this, () => {
      // cleanup runs when Demo is torn down
    });  
  }
}

class Demo extends Component {
  // or 
  get foo() {
    return createService(this, () => new MyState(/* ... */));
  }
}
```

However, note that the same restrictions as with `link` apply: services may not be accessed in the constructor.

And even that caveat can be undone if what you need is passed in to your service's constructor.

[reactiveweb-link]: https://reactive.nullvoxpopuli.com/functions/link.link.html 
