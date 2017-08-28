import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import Navbar from '../../components/navbar/navbar';
import { fetchProps } from '../../actions/props';
import { fetchUsers } from '../../actions/users';


const mapStateToProps = state => ({
});

const mapDispatchToProps = dispatch => ({
  handleLinkClicked: (path) => {
    dispatch(push(path));
  },
  fetchInitialData: () => {
    dispatch(fetchProps());
    dispatch(fetchUsers());
  },
});

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(Navbar);
