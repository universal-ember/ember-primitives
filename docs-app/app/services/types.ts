export interface Manifest {
  first: Page;
  list: Page[][];
  grouped: { [group: string]: Page[] };
}

export interface Page {
  path: string;
  name: string;
  groupName: string;
}
