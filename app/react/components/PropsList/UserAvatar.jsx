import React, { PropTypes } from 'react';

const UserAvatar = ({ avatarPath }) => (
  <img
    className="praised-person-avatar"
    src={avatarPath}
    alt="avatar"
  />
);

UserAvatar.propTypes = {
  avatarPath: PropTypes.string,
};

export default UserAvatar;
