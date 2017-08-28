/* eslint-disable no-unused-expressions */
import chaiEnzyme from 'chai-enzyme';
import chai, { expect } from 'chai';

import * as actions from '../props';
import { RECEIVE_PROPS, RECEIVE_PROPS_PAGE } from '../../constants/props';

jest.unmock('../props');
chai.use(chaiEnzyme());

const currentPage = 1;
const totalPages = 2;

const testData = {
  props: [
    { id: 1, body: 'Test body', upvote: false, users: [{ id: 1, name: 'John' }], propser: { id: 1, name: 'Adam' } },
  ],
  meta: {
    current_page: currentPage,
    total_pages: totalPages,
  },
};


describe('props actions', () => {
  it('should create an action to receive props', () => {
    const expectedAction = {
      type: RECEIVE_PROPS,
      payload: {
        props: testData.props,
      },
    };
    expect(actions.receiveProps(testData)).deep.equal(expectedAction);
  });

  it('should create an action to receive props page', () => {
    const expectedAction = {
      type: RECEIVE_PROPS_PAGE,
      payload: {
        hasPreviousPage: currentPage > 1,
        hasNextPage: currentPage < totalPages,
        currentPage,
      },
    };
    const expectedActionResult = JSON.stringify(actions.receivePropsPage(testData));
    expect(expectedActionResult).deep.equal(JSON.stringify(expectedAction));
  });
});
