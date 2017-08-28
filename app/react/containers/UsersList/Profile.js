import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import Profile from '../../components/UsersList/Profile';
import { fetchUserProfile } from '../../actions/users';

const mapStateToProps = ({ userProfile }) => ({
  userProfile,
});

const mapDispatchToProps = dispatch => ({
  handleClick(path) {
    dispatch(push(path));
  },
  getProfile(userId) {
    dispatch(fetchUserProfile(userId));
  },
});

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(Profile);
