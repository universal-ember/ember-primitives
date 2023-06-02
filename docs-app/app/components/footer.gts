import { ExternalLink,Link } from 'ember-primitives';

export const Footer = <template>
  <footer id="site-footer">
    <div>
      <span class="left">
        <Link @href="/">ember-primitives</Link>
      </span>
      <span class="right">
        <ExternalLink href="/tests">Tests ➚</ExternalLink>
        <ExternalLink href="https://github.com/universal-ember/ember-primitives">GitHub ➚</ExternalLink>
      </span>
    </div>
  </footer>
</template>;
