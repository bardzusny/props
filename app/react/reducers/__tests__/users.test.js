/* eslint-disable no-unused-expressions */
import chaiEnzyme from 'chai-enzyme';
import chai, { expect } from 'chai';
import reducer from '../users';
import { RECEIVE_USERS } from '../../constants/users';

jest.unmock('../users');
chai.use(chaiEnzyme());


const userId = 1;
const testData = { users: [{ id: userId, name: 'John', email: 'john@email.com' }] };
const normalizedTestData = { [userId]: { id: userId, name: 'John', email: 'john@email.com' } };

describe('users reducer', () => {
  it('returns the initial state', () => {
    expect(reducer(undefined, { type: '' })).deep.equal({});
  });

  it('handles RECEIVE_USERS', () => {
    expect(reducer([], {
      type: RECEIVE_USERS,
      payload: testData,
    })).deep.equal(normalizedTestData);
  });
});
