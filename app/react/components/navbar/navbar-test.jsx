import React from 'react';
import ReactDOM from 'react-dom';
import TestUtils from 'react-addons-test-utils';
import expect from 'expect';

import Navbar from './navbar';

const container = document.createElement('div');
let component;

describe('navbar/navbar', () => {
  context('when user is a guest', () => {
    before(() => {
      const props = {
        isOnAppPage: true,
        user: null,
        userSignedIn: false,
      };

      component = ReactDOM.render(<Navbar {...props} />, container);
    });

    after(() => {
      ReactDOM.unmountComponentAtNode(container);
    });

    it('renders', () => {
      expect(TestUtils.findRenderedComponentWithType(component, Navbar)).toExist();
    });

    it('does not have app link', () => {
      expect(component.links.length).toEqual(0);
    });

    it('assigns empty object to user', () => {
      expect(component.user).toEqual({});
    });
  });

  context('when user is signed in', () => {
    context('when user is on app page', () => {
      before(() => {
        const props = {
          isOnAppPage: true,
          user: { name: 'testUser', email: 'testUser@example.com' },
          userSignedIn: true,
        };

        component = ReactDOM.render(<Navbar {...props} />, container);
      });

      after(() => {
        ReactDOM.unmountComponentAtNode(container);
      });

      it('renders', () => {
        expect(TestUtils.findRenderedComponentWithType(component, Navbar)).toExist();
      });

      it('does have app links', () => {
        expect(component.links).toEqual([
          { name: 'Props', url: '#props' },
          { name: 'Users', url: '#users' },
        ]);
      });
    });

    context('when user is on page different than app page', () => {
      before(() => {
        const props = {
          isOnAppPage: false,
          user: { name: 'testUser', email: 'testUser@example.com' },
          userSignedIn: true,
        };

        component = ReactDOM.render(<Navbar {...props} />, container);
      });

      after(() => {
        ReactDOM.unmountComponentAtNode(container);
      });

      it('renders', () => {
        expect(TestUtils.findRenderedComponentWithType(component, Navbar)).toExist();
      });

      it('only has link to app', () => {
        expect(component.links).toEqual([{ name: 'App', url: '/app' }]);
      });
    });
  });
});
