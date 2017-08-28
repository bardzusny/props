import React, { PropTypes } from 'react';
import { isEmpty } from 'lodash';
import Pagination from '../shared/pagination';
import AddProp from './AddProp';
import Prop from './Prop';
import Loader from '../shared/loader';

const PropsList = ({
  propsList,
  users,
  currentUser,
  hasPrevPage,
  hasNextPage,
  onPaginationPrev,
  onPaginationNext,
  currentPage,
  onPropUpvote,
  onPropDownvote,
  onPropSubmit,
  isFetching,
}) => {
  const handlePrevPageClick = (e) => {
    e.preventDefault();
    onPaginationPrev(currentPage - 1);
  };

  const handleNextPageClick = (e) => {
    e.preventDefault();
    onPaginationNext(currentPage + 1);
  };

  const handlePropUpvote = (id) => {
    onPropUpvote(id);
  };

  const handlePropDownvote = (id) => {
    onPropDownvote(id);
  };

  if (isFetching) { return <Loader />; }

  return (
    <div>
      {
        !isEmpty(users) &&
        <AddProp
          users={users}
          currentUser={currentUser}
          onPropSubmit={onPropSubmit}
        />
      }
      {propsList.map(prop =>
        <Prop
          key={prop.id}
          prop={prop}
          vote
          onPropUpvote={handlePropUpvote}
          onPropDownvote={handlePropDownvote}
        />
      )}

      <Pagination
        hasPreviousPage={hasPrevPage}
        hasNextPage={hasNextPage}
        onPrevPageClick={handlePrevPageClick}
        onNextPageClick={handleNextPageClick}
        currentPage={currentPage}
      />
    </div>
  );
};

PropsList.propTypes = {
  propsList: PropTypes.arrayOf(PropTypes.object),
  hasPrevPage: PropTypes.bool.isRequired,
  hasNextPage: PropTypes.bool.isRequired,
  onPaginationPrev: PropTypes.func.isRequired,
  onPaginationNext: PropTypes.func.isRequired,
  onPropUpvote: PropTypes.func.isRequired,
  onPropDownvote: PropTypes.func.isRequired,
  onPropSubmit: PropTypes.func.isRequired,
  currentPage: PropTypes.number.isRequired,
  users: PropTypes.objectOf(PropTypes.object),
  currentUser: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    email: PropTypes.string,
    avatar_url: PropTypes.string,
  }),
  isFetching: PropTypes.bool,
};

export default PropsList;
