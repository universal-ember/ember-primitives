# createStore

This utility will create a stable instance or singleton hosted on any context (component, application, etc). The lifetime of the store is determined by the parent's object's lifetime. Can be used to create private services that don't live in the registry, or any lazily created state private to certain components. Can also be combined wih DOM hierachy crawling to create DOM-based context/contextual state. 

Ownership and destroyable linkage is handled (via [`link`][reactiveweb-link]).

[reactiveweb-link]: https://reactive.nullvoxpopuli.com/functions/link.link.html 

<Callout>

When using `createStore` with the `owner` as the key, you effectively have lazyily included services, as per [RFC #502, "Explicit Service Injection"](https://github.com/emberjs/rfcs/pull/502)

</Callout>


## Install

```hbs live
<SetupInstructions @src="store.ts" />
```


Introduced in [0.38.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.38.0-ember-primitives)

## Usage

 In this example, `MyState` is created once per instance of the component.
 repeat accesses to `this.foo` return a stable reference _as if_ `@cached` were used.

```js
import { createStore } from 'ember-primitives/store';

class MyState {}

class Demo extends Component {
  // lazyily created upon access of `foo`
  get foo() {
    return createStore(this, MyState);
  }

  // or eagrly created when `Demo` is created
  foo = createStore(this, MyState);
}
```

### Usage in a component

```js
import { createStore } from 'ember-primitives/store';

class MyState {}

class Demo extends Component {
  // this is a stable reference
  get foo() {
    return createStore(this, MyState);
  }
}
```

Functions may also be passed. Note however that each function passed is its own key, so `() => new MyClass()` and another `() => new MyClass()` elsewhere are separate arrow functions, and it's not possible to treat them as the same.

### With Arguments

```js
import { createStore } from 'ember-primitives/store';

class MyState {
  constructor(/* .. */ ) { /* ... */ }
}

class Demo extends Component {
  // or 
  get foo() {
    return createStore(this, () => new MyState(1, 2));
  }
}
```

### Accessing Services and handling cleanup 

Like with [`link`][reactiveweb-link], use of services and `registerDestructor` is valid:
```js
import { createStore } from 'ember-primitives/store';
import { service } from '@ember/service';

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
    return createStore(this, () => new MyState(/* ... */));
  }
}
```

However, note that the same restrictions as with `link` apply: services may not be accessed in the constructor.

### Application Singletons

Up until this point, the above examples have all been tied to the lifetime of _the component instance_ -- in that multiple instances of `Demo` would still have different instances of `MyState`.

To address this, the application instance needs to be passed instead of `this`.

For example:

```js
import { createStore } from 'ember-primitives/store';
import { getOwner } from '@ember/owner';

class MyState {}

class Demo extends Component {
  // lazyily created upon access of `foo`.
  // will be the same instance everywhere in the application 
  // 
  get foo() {
    return createStore(getOwner(this), MyState);
  }
}
```

It may be helpful to make a little utility to wrap up the now boilerplate:
```js
import { createStore } from 'ember-primitives/store';
import { getOwner } from '@ember/owner';

class MyState {}

function createState(context) {
  let owner = getOwner(this);
  return createStore(owner, MyState);
}

class Demo extends Component {
  // lazyily created upon access of `foo`.
  // will be the same instance everywhere in the application 
  get foo() {
    return createState(this);
  }
}
```

In this way, you may create private services (useful for libraries) without exposing your service to public usage via the `@service` decorator or registry means -- additionally helpful when consuming ember apps forgo the automatic file-based structure and registrations.
