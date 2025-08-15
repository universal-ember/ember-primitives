import path from 'node:path';

import { packageJson, project } from 'ember-apply';

const root = await project.gitRoot();

for await (const workspace of await project.getWorkspaces()) {
  if (workspace === root) continue;

  const relative = path.join(path.relative(workspace, root), 'package.json');

  await packageJson.modify((json) => {
    json.volta = {
      extends: relative,
    };
  }, workspace);
}
