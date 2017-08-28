import { REQUEST_PROPS_PAGE, RECEIVE_PROPS_PAGE } from '../constants/props';

const initialState = {
  hasPreviousPage: true,
  hasNextPage: true,
  currentPage: 1,
  isFetchingPage: false,
};

const propsPagination = (state = initialState, action = {}) => {
  switch (action.type) {
    case REQUEST_PROPS_PAGE:
      return {
        ...state,
        isFetchingPage: true,
      };
    case RECEIVE_PROPS_PAGE:
      return {
        ...state,
        isFetchingPage: false,
        hasPreviousPage: action.payload.hasPreviousPage,
        hasNextPage: action.payload.hasNextPage,
        currentPage: action.payload.currentPage,
      };
    default:
      return state;
  }
};

export default propsPagination;
