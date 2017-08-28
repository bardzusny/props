import React from 'react';
import { Route, IndexRoute } from 'react-router';

import App from '../containers/App';
import PropsList from '../containers/PropsList';
import UsersList from '../containers/UsersList';
import Profile from '../containers/UsersList/Profile';

export default (
  <Route path="/app" component={App}>
    <IndexRoute component={PropsList} />
    <Route path="users" component={UsersList} />
    <Route path="users/:id" component={Profile} />
  </Route>
);
