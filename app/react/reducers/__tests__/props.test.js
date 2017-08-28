/* eslint-disable no-unused-expressions */
import chaiEnzyme from 'chai-enzyme';
import chai, { expect } from 'chai';
import reducer from '../props';
import { RECEIVE_PROPS } from '../../constants/props';

jest.unmock('../props');
chai.use(chaiEnzyme());


const userId = 99;
const propserId = 88;
const testData = { props: [
  { id: 1, body: 'Test body', upvote: false, users: [{ id: userId, name: 'John' }], propser: { id: propserId, name: 'Adam' } }] };

const normalizedTestData = [
  {
    id: 1,
    body: 'Test body',
    upvote: false,
    users: [99],
    propser: 88,
  },
];

describe('props reducer', () => {
  it('returns the initial state', () => {
    expect(reducer(undefined, { type: '' })).deep.equal([]);
  });

  it('handles RECEIVE_PROPS', () => {
    expect(reducer([], {
      type: RECEIVE_PROPS,
      payload: testData,
    })).deep.equal(normalizedTestData);
  });
});
