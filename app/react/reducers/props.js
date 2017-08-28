import { RECEIVE_PROPS } from '../constants/props';

const props = (state = [], action = {}) => {
  switch (action.type) {
    case RECEIVE_PROPS:
      return action.payload.props.map(prop => ({
        ...prop,
        propser: prop.propser.id,
        users: prop.users.map(u => u.id),
      }));
    default:
      return state;
  }
};

export default props;
