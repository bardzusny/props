import React, { PropTypes } from 'react';
import PropComponent from '../PropsList/Prop';

const UserProps = ({ receivedProps, givenProps }) => (
  <div className="row">
    <div className="col-md-6">
      <h2>Received props</h2>
      <ul className="list-unstyled">
        {
          receivedProps.map(prop => (
            <PropComponent
              key={prop.id}
              prop={prop}
              vote={false}
            />
          ))
        }
      </ul>
    </div>
    <div className="col-md-6">
      <h2>Given props</h2>
      <ul className="list-unstyled">
        {
          givenProps.map(prop => (
            <PropComponent
              key={prop.id}
              prop={prop}
              vote={false}
            />
          ))
        }
      </ul>
    </div>
  </div>
);


const propsShape = {
  id: PropTypes.number,
  users: PropTypes.arrayOf(PropTypes.number),
  propser: PropTypes.number,
  body: PropTypes.string,
  created_at: PropTypes.string,
  upvotes_count: PropTypes.number,
  is_upvote_possible: PropTypes.bool,
  is_undo_upvote_possible: PropTypes.bool,
};

UserProps.propTypes = {
  receivedProps: PropTypes.arrayOf(PropTypes.shape(propsShape)),
  givenProps: PropTypes.arrayOf(PropTypes.shape(propsShape)),
};

UserProps.defaultProps = {
  receivedProps: [],
  givenProps: [],
};

export default UserProps;
