import { connect } from 'react-redux';
import PropsList from '../../components/PropsList';
import {
  fetchProps,
  upvoteProp,
  downvoteProp,
  giveProp } from '../../actions/props';


const mapStateToProps = state => ({
  propsList: state.props,
  users: state.users,
  currentUser: state.user,
  hasPrevPage: state.propsPagination.hasPreviousPage,
  hasNextPage: state.propsPagination.hasNextPage,
  currentPage: state.propsPagination.currentPage,
  isFetching: state.propsPagination.isFetchingPage,
});

const mapDispatchToProps = dispatch => ({
  onPaginationPrev: (prevPage) => {
    dispatch(fetchProps(prevPage));
  },
  onPaginationNext: (nextPage) => {
    dispatch(fetchProps(nextPage));
  },
  onPropUpvote: (id) => {
    dispatch(upvoteProp(id));
  },
  onPropDownvote: (id) => {
    dispatch(downvoteProp(id));
  },
  onPropSubmit: (propserId, usersIds, propBody) => {
    dispatch(giveProp(propserId, usersIds, propBody));
  },
});

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(PropsList);
