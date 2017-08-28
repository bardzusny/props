import React from 'react';
import ReactDOM from 'react-dom';
import TestUtils from 'react-addons-test-utils';
import expect from 'expect';

import NavbarSettings from './navbar-settings';

const container = document.createElement('div');
let component;

describe('navbar/navbar-settings', () => {
  context('when user is a guest', () => {
    before(() => {
      const props = {
        user: {},
        userSignedIn: false,
      };

      component = ReactDOM.render(<NavbarSettings {...props} />, container);
    });

    after(() => {
      ReactDOM.unmountComponentAtNode(container);
    });

    it('renders', () => {
      expect(TestUtils.findRenderedComponentWithType(component, NavbarSettings)).toExist();
    });

    it('shows only login link', () => {
      const link = TestUtils.findRenderedDOMComponentWithTag(component, 'a');

      expect(link.getAttribute('href')).toEqual('/signin');
      expect(link.textContent).toEqual('Login');
    });
  });

  context('when user is signed in', () => {
    before(() => {
      const props = {
        user: { name: 'testUser', email: 'testUser@example.com' },
        userSignedIn: true,
      };

      component = ReactDOM.render(<NavbarSettings {...props} />, container);
    });

    after(() => {
      ReactDOM.unmountComponentAtNode(container);
    });

    it('renders', () => {
      expect(TestUtils.findRenderedComponentWithType(component, NavbarSettings)).toExist();
    });

    it('shows settings and logout links', () => {
      const links = TestUtils
        .findRenderedDOMComponentWithClass(component, 'dropdown-menu')
        .getElementsByTagName('a');

      expect(links.length).toEqual(2);
      expect(links[0].getAttribute('href')).toEqual('/settings');
      expect(links[0].textContent).toEqual('Settings');
      expect(links[1].getAttribute('href')).toEqual('/signout');
      expect(links[1].textContent).toEqual('Logout');
    });

    it('shows users email and name', () => {
      const dropDown = TestUtils.findRenderedDOMComponentWithClass(component, 'dropdown-toggle');

      expect(dropDown.firstChild.textContent).toEqual('testUser (testUser@example.com)');
    });
  });
});
