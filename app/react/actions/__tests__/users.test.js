/* eslint-disable no-unused-expressions */
import chaiEnzyme from 'chai-enzyme';
import chai, { expect } from 'chai';

import * as actions from '../users';
import { RECEIVE_USERS } from '../../constants/users';

jest.unmock('../props');
chai.use(chaiEnzyme());

const testData = { users: [{ id: 1, name: 'John', email: 'john@email.com' }] };


describe('users actions', () => {
  it('should create an action to receive users', () => {
    const expectedAction = {
      type: RECEIVE_USERS,
      payload: {
        users: testData,
      },
    };
    const expectedActionResult = JSON.stringify(actions.receiveUsers(testData));
    expect(expectedActionResult).deep.equal(JSON.stringify(expectedAction));
  });
});
