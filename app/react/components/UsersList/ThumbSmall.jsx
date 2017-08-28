import React, { PropTypes } from 'react';

const ThumbSmall = ({ id, name, avatarUrl, handleClick }) => {
  const userUrl = `/app/users/${id}`;
  const handleProfileClick = (e) => {
    e.preventDefault();
    handleClick(userUrl);
  };


  if (!(id && name && avatarUrl)) { return null; }

  return (
    <a
      href={userUrl}
      className="props-receiver-avatar"
      onClick={handleProfileClick}
    >
      <img src={avatarUrl} title={name} alt="avatar" />
      <span className="props-receiver-name">{name.match(/^\w*/).toString()}</span>
    </a>
  );
};

ThumbSmall.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  avatarUrl: PropTypes.string.isRequired,
  handleClick: PropTypes.func.isRequired,
};

export default ThumbSmall;
