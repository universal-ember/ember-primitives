import { execa } from 'execa';

/**
 * I hope one day turbo implements --dry-run --json and I can delete all this
 */

async function pending(command) {
  let { stdout } = await execa('pnpm', ['turbo', 'run', command, '--dry-run']);

  let [, info] = stdout.split('Tasks to Run');
  let lines = info.split('\n').filter(Boolean);

  let groups = [];
  let currentGroup = [];

  for (let line of lines) {
    if (!line.match(/^\s/)) {
      if (currentGroup) {
        groups.push(currentGroup);
      }

      currentGroup = [line];

      continue;
    }

    currentGroup.push(line);
  }

  groups.push(currentGroup);

  groups = groups.filter((group) => group.length);
  groups = groups.map((group) => group.map((line) => line.trim()));

  let result = {};

  // change to project => cached status
  for (let group of groups) {
    let [title, ...lines] = group;

    if (!title.includes(command)) {
      continue;
    }

    let [projectName] = title.split('#');
    let cacheLine = lines.find((line) => line.includes('Cached (Remote)'));
    let localCacheLine = lines.find((line) => line.includes('Cached (Local)'));
    let isCached =
      cacheLine.includes('true') || localCacheLine.includes('true');

    result[projectName] = isCached;
  }

  return result;
}

/**
 * This is only based on what is in ci.yml
 * What these cover, and how they're dirtied,
 * and what projects they dirty in what order
 * is determined by the turbo.json
 */
async function gather() {
  let lint = await pending('_:lint');
  let test = await pending('test');
  let typecheck = await pending('lint:types');

  console.info(
    JSON.stringify({
      lint,
      test,
      typecheck,
      atAll: {
        lint: Object.values(lint).every(Boolean),
        test: Object.values(test).every(Boolean),
        typecheck: Object.values(typecheck).every(Boolean),
      },
    })
  );
}

await gather();
