import React, { Component, PropTypes } from 'react';
import { get } from 'lodash';

import UserStats from './UserStats';
import PropsList from './UserProps';
import Loader from '../shared/loader';

class Profile extends Component {
  componentDidMount() {
    this.props.getProfile(this.props.params.id);
  }

  componentWillReceiveProps(nextProps) {
    const nextId = nextProps.params.id;
    if (this.props.params.id !== nextId) {
      this.props.getProfile(nextId);
    }
  }

  render() {
    const {
      name,
      archived,
      receivedProps,
      givenProps,
      props_count: count,
      isFetching,
    } = this.props.userProfile;
    if (isFetching) { return <Loader />; }

    return (
      <div>
        <UserStats
          userName={name}
          propsReceivedCount={get(count, 'received', 0)}
          propsGivenCount={get(count, 'given', 0)}
          archived={archived}
        />

        <PropsList
          givenProps={givenProps}
          receivedProps={receivedProps}
        />
      </div>
    );
  }
}

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

Profile.propTypes = {
  userProfile: PropTypes.shape({
    name: PropTypes.string,
    archived: PropTypes.bool,
    receivedProps: PropTypes.arrayOf(PropTypes.shape(propsShape)),
    givenProps: PropTypes.arrayOf(PropTypes.shape(propsShape)),
    props_count: PropTypes.shape({
      received: PropTypes.number,
      given: PropTypes.number,
    }),
    isFetching: PropTypes.bool,
  }),
  params: PropTypes.shape({
    id: PropTypes.string.isRequired,
  }),
  getProfile: PropTypes.func,
};

Profile.defaultProps = {
  userProfile: {},
};

export default Profile;
