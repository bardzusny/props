/* eslint-disable no-unused-expressions */
import _noop from 'lodash/noop';
import React from 'react';
import chaiEnzyme from 'chai-enzyme';
import { shallow } from 'enzyme';
import chai, { expect } from 'chai';
import PropsList from '../index';

jest.unmock('../index');
chai.use(chaiEnzyme());

const wrapper = shallow(
  <PropsList
    propsList={[]}
    hasPrevPage
    hasNextPage
    onPaginationPrev={_noop}
    onPaginationNext={_noop}
    onPropUpvote={_noop}
    onPropDownvote={_noop}
    onPropSubmit={_noop}
    currentPage={2}
  />
);

describe('<Pagination />', () => {
  it('renders', () => {
    expect(wrapper).to.exist;
  });
});
