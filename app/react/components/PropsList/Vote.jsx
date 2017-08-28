import React from 'react';

import _noop from 'lodash/noop';

const Vote = ({
  onUpvote,
  upvotesCount,
  isUpvotePossible,
  isUndoUpvotePossible,
  undoUpvote,
}) => {
  const ratingButton = (
    <button
      data-test="rating"
      className="btn btn-default"
      disabled
    >
      Rating + {upvotesCount}
    </button>
  );

  const upvoteButton = (
    <button
      data-test="upvote"
      className="btn btn-success"
      onClick={onUpvote}
    >
      +1
    </button>
  );

  const undoUpvoteButton = (
    <button
      data-test="undo-upvote"
      className="btn btn-danger"
      onClick={undoUpvote}
    >
      -1
    </button>
  );

  return (
    <div className="btn-group pull-right">
      { upvotesCount > 0 && ratingButton }
      { isUpvotePossible && upvoteButton }
      { isUndoUpvotePossible && undoUpvoteButton }
    </div>
  );
};

Vote.propTypes = {
  onUpvote: React.PropTypes.func,
  upvotesCount: React.PropTypes.number,
  isUpvotePossible: React.PropTypes.bool,
  isUndoUpvotePossible: React.PropTypes.bool,
  undoUpvote: React.PropTypes.func,
};

Vote.defaultProps = {
  upvotesCount: 0,
  onUpvote: _noop,
  undoUpvote: _noop,
  isUpvotePossible: false,
  isUndoUpvotePossible: false,
};

export default Vote;
