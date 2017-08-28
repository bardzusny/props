/* eslint-disable no-unused-expressions */
import React from 'react';
import chaiEnzyme from 'chai-enzyme';
import { shallow, mount } from 'enzyme';
import chai, { expect } from 'chai';
import Pagination from '../pagination';

jest.unmock('../pagination');
chai.use(chaiEnzyme());

const prevPageHandlerMock = jest.fn();
const nextPageHandlerMock = jest.fn();
const pageNumber = 2;

const wrapper = mount(
  <Pagination
    hasNextPage
    hasPreviousPage
    onPrevPageClick={prevPageHandlerMock}
    onNextPageClick={nextPageHandlerMock}
    currentPage={pageNumber}
  />
);

const wrapperWithNoPrev = shallow(
  <Pagination
    hasNextPage
    hasPreviousPage={false}
    onPrevPageClick={prevPageHandlerMock}
    onNextPageClick={nextPageHandlerMock}
    currentPage={pageNumber}
  />
);

const wrapperWithNoNext = shallow(
  <Pagination
    hasNextPage={false}
    hasPreviousPage
    onPrevPageClick={prevPageHandlerMock}
    onNextPageClick={nextPageHandlerMock}
    currentPage={pageNumber}
  />
);

describe('<Pagination />', () => {
  it('renders', () => {
    expect(wrapper).to.exist;
  });

  it('displays current page button', () => {
    expect(wrapper.find('.current-page')).to.have.text(pageNumber);
  });

  it('displays current page button', () => {
    expect(wrapper.find('.current-page')).to.have.text(pageNumber);
  });
});

describe('Previous page link ', () => {
  it('is not visible when hasPreviousPage prop is false', () => {
    expect(wrapperWithNoPrev.find('.previous-page')).to.not.exist;
  });

  it('calls previous page handler', () => {
    wrapper.find('.previous-page').simulate('click');
    expect(prevPageHandlerMock.mock.calls.length).equal(1);
  });
});

describe('Next page link', () => {
  it('is not visible when hasNextPage prop is false', () => {
    expect(wrapperWithNoNext.find('.next-page')).to.not.exist;
  });

  it('calls previous page handler', () => {
    wrapper.find('.next-page').simulate('click');
    expect(nextPageHandlerMock.mock.calls.length).equal(1);
  });
});
