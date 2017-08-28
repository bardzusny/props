import React, { PropTypes } from 'react';

const UserStats = ({ userName, propsReceivedCount, propsGivenCount, archived }) => (
  <div>
    <h1>
      Displaying <strong>{userName}</strong> profile:
    </h1>
    <div className="well well-sm">
      <div className="row">
        <div className="col-sm-6 col-md-8">
          <h4>
            {userName} {archived && '(archived)'}
          </h4>
          <p>
            <i className="glyphicon glyphicon-thumbs-up user-stats__icon" />
            Props received: <span className="label label-success">{propsReceivedCount}</span>
          </p>
          <p>
            <i className="glyphicon glyphicon-gift user-stats__icon" />
            Props given: <span className="label label-info">{propsGivenCount}</span>
          </p>
        </div>
      </div>
    </div>
  </div>
);

UserStats.propTypes = {
  userName: PropTypes.string.isRequired,
  propsReceivedCount: PropTypes.number.isRequired,
  propsGivenCount: PropTypes.number.isRequired,
  archived: PropTypes.bool,
};

UserStats.defaultProps = {
  userName: '',
  propsReceivedCount: 0,
  propsGivenCount: 0,
  archived: false,
};

export default UserStats;
