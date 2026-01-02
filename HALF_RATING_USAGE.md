# Half-Rating Support

The Rating component now supports half-ratings and fractional values! Here's how to use it:

## Basic Half-Star Rating

```gts
import { Rating } from 'ember-primitives';

<template>
  <Rating 
    @step={{0.5}}
    @iconHalf="⯨"
    @value={{3.5}}
  />
</template>
```

## Features Added

### 1. **`@step` Property**
Controls the increment for rating values:
- `@step={{1}}` - Whole stars only (default)
- `@step={{0.5}}` - Half-star ratings
- `@step={{0.25}}` - Quarter-star ratings

### 2. **`@iconHalf` Property**
Specifies the icon to use for half-selected stars:
- Works with string icons: `@iconHalf="⯨"` (half-star symbol)
- Works with component icons: The component receives `@percentSelected` to render partial states
- Defaults to the same as `@icon`

### 3. **Fractional Value Support**
The `@value` property now accepts decimals:
```gts
<Rating @value={{3.5}} @step={{0.5}} />  // Shows 3.5 stars
<Rating @value={{4.25}} @step={{0.25}} /> // Shows 4.25 stars
```

## Usage Examples

### Example 1: Half-Stars with String Icons

```gts
<template>
  <Rating 
    @icon="★"
    @iconHalf="⯨"
    @step={{0.5}}
    @value={{3.5}}
    @onChange={{this.handleRatingChange}}
  />
</template>
```

### Example 2: Custom Component Icons with Percentage

For more control over rendering, use a component that receives `@percentSelected`:

```gts
const StarIcon = <template>
  <svg ...attributes>
    {{#if (gt @percentSelected 0)}}
      {{#if (lt @percentSelected 100)}}
        <!-- Render half-filled star based on @percentSelected -->
        <defs>
          <linearGradient id="half-{{@value}}">
            <stop offset="{{@percentSelected}}%" stop-color="gold" />
            <stop offset="{{@percentSelected}}%" stop-color="gray" />
          </linearGradient>
        </defs>
        <path fill="url(#half-{{@value}})" d="..." />
      {{else}}
        <!-- Full star -->
        <path fill="gold" d="..." />
      {{/if}}
    {{else}}
      <!-- Empty star -->
      <path fill="gray" d="..." />
    {{/if}}
  </svg>
</template>

<template>
  <Rating @icon={{StarIcon}} @step={{0.5}} @value={{3.5}} />
</template>
```

### Example 3: Read-Only Half-Star Display

```gts
<template>
  <Rating 
    @value={{4.7}}
    @step={{0.1}}
    @iconHalf="⯨"
    @interactive={{false}}
  />
</template>
```

### Example 4: Using Range Input for Precise Control

```gts
<template>
  <Rating @step={{0.5}} as |rating|>
    <rating.Range step="0.5" />
    <rating.Stars />
  </Rating>
</template>
```

## Technical Implementation

### How It Works

1. **State Management**: The `RatingState` component rounds values to the nearest step to avoid floating-point precision issues
2. **Visual Rendering**: The `Stars` component checks `data-percent-selected` to determine if a star should show as half-filled
3. **Accessibility**: Half-ratings maintain full accessibility with proper ARIA attributes and keyboard navigation
4. **Toggle Behavior**: Clicking the same rating value toggles it to 0, even with fractional values

### Data Attributes

The component adds these data attributes for styling and testing:
- `data-value`: Current rating value (e.g., "3.5")
- `data-percent-selected`: Percentage of selection for each star (0-100)
- `data-selected`: Boolean indicating if the star is selected
- `data-number`: The star's position number

## CSS Styling

You can target half-selected stars with CSS:

```css
.ember-primitives__rating__item[data-percent-selected="50"] {
  /* Style half-filled stars */
}

.ember-primitives__rating__item[data-selected="true"] {
  /* Style fully selected stars */
  color: gold;
}

.ember-primitives__rating__item[data-selected="false"] {
  /* Style unselected stars */
  color: gray;
}
```

## Testing Support

The test helper automatically detects half-ratings:

```ts
import { rating } from 'ember-primitives/test-support';

test('half ratings work', async function(assert) {
  await render(<template><Rating @step={{0.5}} /></template>);
  
  const ratingHelper = rating();
  
  await ratingHelper.select(3.5);
  assert.strictEqual(ratingHelper.value, 3.5);
  // The stars property will show ⯨ for half stars
});
```

## Migration Guide

Existing rating implementations will continue to work without changes. Half-rating is opt-in:

**Before (whole stars only):**
```gts
<Rating @value={{3}} />
```

**After (same behavior):**
```gts
<Rating @value={{3}} />
```

**After (with half-stars):**
```gts
<Rating @value={{3.5}} @step={{0.5}} @iconHalf="⯨" />
```

## Browser Support

Half-ratings work in all modern browsers. The implementation uses standard HTML5 features and doesn't require any polyfills.
