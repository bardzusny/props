import assign from 'lodash/assign';

import {
  RECEIVE_USER,
  REQUEST_USER,
} from '../constants/action-types';

function user(state = {}, action) {
  switch (action.type) {
    case RECEIVE_USER:
      return assign({}, state, action.user);
    case REQUEST_USER:
      return {};
    default:
      return state;
  }
}

export default user;
