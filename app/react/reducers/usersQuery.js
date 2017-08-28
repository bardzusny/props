import { SET_USERS_QUERY } from '../constants/users';

const usersQuery = (state = '', action = {}) => {
  switch (action.type) {
    case SET_USERS_QUERY:
      return action.payload.query;
    default:
      return state;
  }
};

export default usersQuery;
