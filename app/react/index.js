import RWR, { integrationsManager } from 'react-webpack-rails';
import React from 'react';
import ReactDOM from 'react-dom';
import RWRRedux from 'rwr-redux';

RWR.run();
window.React = React;
window.ReactDOM = ReactDOM;

integrationsManager.register('redux-store', RWRRedux.storeIntegrationWrapper);
integrationsManager.register('redux-container', RWRRedux.containerIntegrationWrapper);
integrationsManager.register('redux-router', RWRRedux.routerIntegrationWrapper);


import Store from './store/configure-store';
RWRRedux.registerStore('Store', Store);

import NavbarComponent from './components/navbar/navbar';

RWR.registerComponent('NavbarComponent', NavbarComponent);

import Navbar from './containers/Navbar';
RWRRedux.registerContainer('Navbar', Navbar);

import PropsList from './containers/PropsList';
RWRRedux.registerContainer('PropsList', PropsList);

import UsersList from './containers/UsersList';
RWRRedux.registerContainer('UsersList', UsersList);

import MainRoutes from './routes';
RWRRedux.registerRoutes('MainRoutes', MainRoutes);
