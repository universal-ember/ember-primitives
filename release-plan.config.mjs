/**
 * Options for the whole repo.
 * Options for one package go in the "release-plan" key of its package.json.
 *
 * https://github.com/NullVoxPopuli/release-plan/blob/next/docs/changelog.md
 */
export default {
  /**
   * NullVoxPopuli-ai-agent is a bot account that opens PRs for NullVoxPopuli.
   */
  renameCommitters: {
    'NullVoxPopuli-ai-agent': 'NullVoxPopuli',
  },
};
