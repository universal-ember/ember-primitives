import type { TOC } from '@ember/component/template-only';

/**
 * Copied from font-awesome directly,
 * but with the addition of fill="currentColor"
 *
 * Font Awesome Free 6.6.0 by @fontawesome
 * - https://fontawesome.com License
 * - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.
 */
export const XTwitter: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" ...attributes>
    <use xlink:href="#social-xtwitter" />
  </svg>
</template>;

export const Discord: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" ...attributes>
    <use xlink:href="#social-discord" />
  </svg>
</template>;

export const Threads: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" ...attributes>
    <use xlink:href="#social-threads" />
  </svg>
</template>;

export const BlueSky: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" ...attributes>
    <use xlink:href="#social-bluesky" />
  </svg>
</template>;

export const Mastodon: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" ...attributes>
    <use xlink:href="#social-mastodon" />
  </svg>
</template>;

export const GitHub: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" ...attributes>
    <use xlink:href="#social-github" />
  </svg>
</template>;

export const Flask: TOC<{ Element: SVGElement }> = <template>
  <svg
    fill="currentColor"
    xmlns="http://www.w3.org/2000/svg"
    height="1em"
    viewBox="0 0 448 512"
    ...attributes
  >{{!! Font Awesome Free 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. }}<path
      d="M288 0H160 128C110.3 0 96 14.3 96 32s14.3 32 32 32V196.8c0 11.8-3.3 23.5-9.5 33.5L10.3 406.2C3.6 417.2 0 429.7 0 442.6C0 480.9 31.1 512 69.4 512H378.6c38.3 0 69.4-31.1 69.4-69.4c0-12.8-3.6-25.4-10.3-36.4L329.5 230.4c-6.2-10.1-9.5-21.7-9.5-33.5V64c17.7 0 32-14.3 32-32s-14.3-32-32-32H288zM192 196.8V64h64V196.8c0 23.7 6.6 46.9 19 67.1L309.5 320h-171L173 263.9c12.4-20.2 19-43.4 19-67.1z"
    /></svg>
</template>;

export const Menu: TOC<{ Element: SVGElement }> = <template>
  <svg
    aria-hidden="true"
    viewBox="0 0 24 24"
    fill="none"
    stroke-width="2"
    stroke-linecap="round"
    ...attributes
  >
    <path d="M4 7h16M4 12h16M4 17h16" />
  </svg>
</template>;

export const Sun: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" viewBox="0 0 16 16" ...attributes>
    <path
      fill-rule="evenodd"
      clip-rule="evenodd"
      d="M7 1a1 1 0 0 1 2 0v1a1 1 0 1 1-2 0V1Zm4 7a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm2.657-5.657a1 1 0 0 0-1.414 0l-.707.707a1 1 0 0 0 1.414 1.414l.707-.707a1 1 0 0 0 0-1.414Zm-1.415 11.313-.707-.707a1 1 0 0 1 1.415-1.415l.707.708a1 1 0 0 1-1.415 1.414ZM16 7.999a1 1 0 0 0-1-1h-1a1 1 0 1 0 0 2h1a1 1 0 0 0 1-1ZM7 14a1 1 0 1 1 2 0v1a1 1 0 1 1-2 0v-1Zm-2.536-2.464a1 1 0 0 0-1.414 0l-.707.707a1 1 0 0 0 1.414 1.414l.707-.707a1 1 0 0 0 0-1.414Zm0-8.486A1 1 0 0 1 3.05 4.464l-.707-.707a1 1 0 0 1 1.414-1.414l.707.707ZM3 8a1 1 0 0 0-1-1H1a1 1 0 0 0 0 2h1a1 1 0 0 0 1-1Z"
    />
  </svg>
</template>;

export const Moon: TOC<{ Element: SVGElement }> = <template>
  <svg aria-hidden="true" viewBox="0 0 16 16" ...attributes>
    <path
      fill-rule="evenodd"
      clip-rule="evenodd"
      d="M7.23 3.333C7.757 2.905 7.68 2 7 2a6 6 0 1 0 0 12c.68 0 .758-.905.23-1.332A5.989 5.989 0 0 1 5 8c0-1.885.87-3.568 2.23-4.668ZM12 5a1 1 0 0 1 1 1 1 1 0 0 0 1 1 1 1 0 1 1 0 2 1 1 0 0 0-1 1 1 1 0 1 1-2 0 1 1 0 0 0-1-1 1 1 0 1 1 0-2 1 1 0 0 0 1-1 1 1 0 0 1 1-1Z"
    />
  </svg>
</template>;

export const LightBulb: TOC<{ Element: SVGElement }> = <template>
  <svg
    aria-hidden="true"
    viewBox="0 0 32 32"
    fill="none"
    class="[--icon-foreground:theme(colors.slate.900)] [--icon-background:theme(colors.white)]"
    ...attributes
  >
    <defs>
      <radialGradient
        cx="0"
        cy="0"
        r="1"
        gradientUnits="userSpaceOnUse"
        id=":S6:-gradient"
        gradientTransform="matrix(0 21 -21 0 20 11)"
      >
        <stop stop-color="#0EA5E9"></stop><stop stop-color="#22D3EE" offset=".527"></stop>
        <stop stop-color="#818CF8" offset="1"></stop>
      </radialGradient>
      <radialGradient
        cx="0"
        cy="0"
        r="1"
        gradientUnits="userSpaceOnUse"
        id=":S6:-gradient-dark"
        gradientTransform="matrix(0 24.5001 -19.2498 0 16 5.5)"
      >
        <stop stop-color="#0EA5E9"></stop><stop stop-color="#22D3EE" offset=".527"></stop>
        <stop stop-color="#818CF8" offset="1"></stop>
      </radialGradient></defs>
    <g class="dark:hidden">
      <circle cx="20" cy="20" r="12" fill="url(#:S6:-gradient)"></circle>
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M20 24.995c0-1.855 1.094-3.501 2.427-4.792C24.61 18.087 26 15.07 26 12.231 26 7.133 21.523 3 16 3S6 7.133 6 12.23c0 2.84 1.389 5.857 3.573 7.973C10.906 21.494 12 23.14 12 24.995V27a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2v-2.005Z"
        class="fill-[var(--icon-background)]"
        fill-opacity="0.5"
      ></path>
      <path
        d="M25 12.23c0 2.536-1.254 5.303-3.269 7.255l1.391 1.436c2.354-2.28 3.878-5.547 3.878-8.69h-2ZM16 4c5.047 0 9 3.759 9 8.23h2C27 6.508 21.998 2 16 2v2Zm-9 8.23C7 7.76 10.953 4 16 4V2C10.002 2 5 6.507 5 12.23h2Zm3.269 7.255C8.254 17.533 7 14.766 7 12.23H5c0 3.143 1.523 6.41 3.877 8.69l1.392-1.436ZM13 27v-2.005h-2V27h2Zm1 1a1 1 0 0 1-1-1h-2a3 3 0 0 0 3 3v-2Zm4 0h-4v2h4v-2Zm1-1a1 1 0 0 1-1 1v2a3 3 0 0 0 3-3h-2Zm0-2.005V27h2v-2.005h-2ZM8.877 20.921C10.132 22.136 11 23.538 11 24.995h2c0-2.253-1.32-4.143-2.731-5.51L8.877 20.92Zm12.854-1.436C20.32 20.852 19 22.742 19 24.995h2c0-1.457.869-2.859 2.122-4.074l-1.391-1.436Z"
        class="fill-[var(--icon-foreground)]"
      ></path>
      <path
        d="M20 26a1 1 0 1 0 0-2v2Zm-8-2a1 1 0 1 0 0 2v-2Zm2 0h-2v2h2v-2Zm1 1V13.5h-2V25h2Zm-5-11.5v1h2v-1h-2Zm3.5 4.5h5v-2h-5v2Zm8.5-3.5v-1h-2v1h2ZM20 24h-2v2h2v-2Zm-2 0h-4v2h4v-2Zm-1-10.5V25h2V13.5h-2Zm2.5-2.5a2.5 2.5 0 0 0-2.5 2.5h2a.5.5 0 0 1 .5-.5v-2Zm2.5 2.5a2.5 2.5 0 0 0-2.5-2.5v2a.5.5 0 0 1 .5.5h2ZM18.5 18a3.5 3.5 0 0 0 3.5-3.5h-2a1.5 1.5 0 0 1-1.5 1.5v2ZM10 14.5a3.5 3.5 0 0 0 3.5 3.5v-2a1.5 1.5 0 0 1-1.5-1.5h-2Zm2.5-3.5a2.5 2.5 0 0 0-2.5 2.5h2a.5.5 0 0 1 .5-.5v-2Zm2.5 2.5a2.5 2.5 0 0 0-2.5-2.5v2a.5.5 0 0 1 .5.5h2Z"
        class="fill-[var(--icon-foreground)]"
      ></path>
    </g>
    <g class="hidden dark:inline">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M16 2C10.002 2 5 6.507 5 12.23c0 3.144 1.523 6.411 3.877 8.691.75.727 1.363 1.52 1.734 2.353.185.415.574.726 1.028.726H12a1 1 0 0 0 1-1v-4.5a.5.5 0 0 0-.5-.5A3.5 3.5 0 0 1 9 14.5V14a3 3 0 1 1 6 0v9a1 1 0 1 0 2 0v-9a3 3 0 1 1 6 0v.5a3.5 3.5 0 0 1-3.5 3.5.5.5 0 0 0-.5.5V23a1 1 0 0 0 1 1h.36c.455 0 .844-.311 1.03-.726.37-.833.982-1.626 1.732-2.353 2.354-2.28 3.878-5.547 3.878-8.69C27 6.507 21.998 2 16 2Zm5 25a1 1 0 0 0-1-1h-8a1 1 0 0 0-1 1 3 3 0 0 0 3 3h4a3 3 0 0 0 3-3Zm-8-13v1.5a.5.5 0 0 1-.5.5 1.5 1.5 0 0 1-1.5-1.5V14a1 1 0 1 1 2 0Zm6.5 2a.5.5 0 0 1-.5-.5V14a1 1 0 1 1 2 0v.5a1.5 1.5 0 0 1-1.5 1.5Z"
        fill="url(#:S6:-gradient-dark)"
      ></path>
    </g>
  </svg>
</template>;
