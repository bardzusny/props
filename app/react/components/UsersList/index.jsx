import React, { PropTypes } from 'react';
import Thumb from './Thumb';

const UsersList = ({ users, filterUsers, goToUserProfile }) => (
  <div>
    <div className="page-header">
      <h1>Users</h1>
      <form>
        <input type="text" onChange={e => filterUsers(e.target.value)} />
      </form>
    </div>
    <div className="row">
      {
        users.map(u => (
          <Thumb
            key={u.id}
            id={u.id}
            name={u.name}
            avatarUrl={u.avatar_url}
            handleClick={goToUserProfile}
          />
        ))
      }
    </div>
  </div>
);

UsersList.propTypes = {
  users: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    email: PropTypes.string,
    avatar_url: PropTypes.string,
  })),
  filterUsers: PropTypes.func,
  goToUserProfile: PropTypes.func,
};

export default UsersList;
