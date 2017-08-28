/* eslint-disable no-unused-expressions */
import React from 'react';
import chaiEnzyme from 'chai-enzyme';
import { shallow } from 'enzyme';
import chai, { expect } from 'chai';
import NavbarLink from '../navbar-link';

jest.unmock('../navbar-link');
chai.use(chaiEnzyme());

const linkProps = {
  key: '1',
  isRoutable: false,
  link: { name: 'Users', url: '/users' },
  onLinkClick() {},
};

describe('<NavbarLink />', () => {
  it('renders link', () => {
    const wrapper = shallow(
      <NavbarLink
        key={linkProps.key}
        isRoutable={linkProps.isRoutable}
        link={linkProps.link}
        onLinkClick={linkProps.onLinkClick}
      />
    );
    expect(wrapper.find('a')).to.have.text(linkProps.link.name);
  });
});
