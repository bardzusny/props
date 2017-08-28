/* eslint-disable no-unused-expressions */
import React from 'react';
import _noop from 'lodash/noop';
import chaiEnzyme from 'chai-enzyme';
import { shallow } from 'enzyme';
import chai, { expect } from 'chai';
import ThumbSmall from '../ThumbSmall';

jest.unmock('../ThumbSmall');
chai.use(chaiEnzyme());

const props = {
  id: 1,
  avatarUrl: 'https://test1.img',
  name: 'name',
  handleClick: _noop,
};

const component = shallow(
  <ThumbSmall {...props} />
);

describe('<ThumbSmall />', () => {
  it('renders', () => {
    expect(component).to.exist;
  });

  it('links to user page', () => {
    const url = `/app/users/${props.id}`;
    expect(component.find({ href: url })).to.exist;
  });

  it('displays user avatar', () => {
    const element = component.find({ src: props.avatarUrl });
    expect(element).to.exist;
  });
});
