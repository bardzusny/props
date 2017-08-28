import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import { get } from 'lodash';
import User from '../../components/UsersList/ThumbSmall';


const setPropsWithDefault = (obj, userId, field, defaultValue) => (
  get(obj, `[${userId}].${field}`, defaultValue)
);

const mapStateToProps = ({ users }, { userId }) => ({
  id: setPropsWithDefault(users, userId, 'id', 0),
  name: setPropsWithDefault(users, userId, 'name', ''),
  avatarUrl: setPropsWithDefault(users, userId, 'avatar_url', ''),
});

const mapDispatchToProps = dispatch => ({
  handleClick: (path) => {
    dispatch(push(path));
  },
});

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(User);
