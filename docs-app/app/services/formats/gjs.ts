import { compileJS } from 'ember-repl';


import type { CompilationResult } from './types';

export async function compile(gjsInput: string): Promise<CompilationResult> {
  try {
    let { ENSURE } = await import('./ensure');
    let { component, ...rest } = await compileJS(gjsInput, ENSURE);


    return { ...rest, rootComponent: component };
  } catch (error) {
    return { error: error as Error };
  }
}
