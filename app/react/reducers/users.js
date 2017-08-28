import assign from 'lodash/assign';
import { RECEIVE_USERS } from '../constants/users';

const users = (state = {}, action = {}) => {
  switch (action.type) {
    case RECEIVE_USERS:
      return assign({}, state,
        ...action.payload.users.map(user => ({ [user.id]: user }))
      );
    default:
      return state;
  }
};

export default users;
