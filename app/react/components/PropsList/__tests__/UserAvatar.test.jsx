/* eslint-disable no-unused-expressions */
import React from 'react';
import chaiEnzyme from 'chai-enzyme';
import { shallow } from 'enzyme';
import chai, { expect } from 'chai';
import UserAvatar from '../UserAvatar';

jest.unmock('../UserAvatar');
chai.use(chaiEnzyme());

const avatarUrl = 'https://test1.img';

const component = shallow(
  <UserAvatar avatarPath={avatarUrl} />
);

describe('<UserAvatar />', () => {
  it('displays user avatar', () => {
    const element = component.find({ src: avatarUrl });
    expect(element).to.exist;
  });
});
