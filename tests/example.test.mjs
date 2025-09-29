import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { add } from '../src/example.mjs';

describe('add', () => {
  it('adds two numbers', () => {
    assert.equal(add(2, 3), 5);
  });
});
