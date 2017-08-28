import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import props from './props';
import propsPagination from './props-pagination';
import user from './user';
import users from './users';
import usersQuery from './usersQuery';
import userProfile from './user-profile';

const rootReducer = combineReducers({
  props,
  propsPagination,
  users,
  user,
  usersQuery,
  routing: routerReducer,
  userProfile,
});

export default rootReducer;
