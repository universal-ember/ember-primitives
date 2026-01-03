# createService

This utility will create a _private_ service using a class definition similar to what is described in [RFC#502](https://github.com/emberjs/rfcs/pull/502) for explicit service injection -- no longer using strings. This allows module graphs to shake out services that aren't used until they are _needed_.

[rfc-502]: https://github.com/emberjs/rfcs/pull/502
[gh-polaris-service]: https://github.com/chancancode/ember-polaris-service
[createStore]: /6-utils/createStore.md

<Callout>

`createService` is not meant to be a replacement for `@service`, but more so a _very small_ utility (one line?) that gets you the spirit of [RFC#502][rfc-502], but without covering all the needed use cases for something that would be built in to the framework.

  For a more robust and whollistic approach to services using the class definition as a key, you may be interested in [ember-polaris-service][gh-polaris-service].
  You can do this yourself with:

  You can do this yourself with:
  ```js
  let serviceInstance = createStore(findOwner(this), ClassDefinition);
  ```

</Callout>


## Setup

```hbs live
<SetupInstructions @src="service.ts" />
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


## Testing

Testing with `createService` is a little different from  the `@service` from ember. In particular, `createService` takes the approach that the whole implementation is a black box, hidden, or private from the caller.
You can still unit test the service as you would any other class. But for consmers, mocking is not supported. If there is a state that needs to be tested, the component(s) owning the service should manipulate the service in to getting in to that state.

If the service is performing operations with the network, you'll want to mock the network -- with tools such as [MSW](https://mswjs.io/), or [WarpDrive](https://warp-drive.io/)'s holodeck.


