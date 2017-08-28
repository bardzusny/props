import React from 'react';

export default class SelectedUsers extends React.Component {
  static get propTypes() {
    return {
      avatars: React.PropTypes.array.isRequired,
    };
  }
  render() {
    const list = this.props.avatars.map((avatarUrl, index) =>
      <img
        className="praised-person-avatar"
        src={avatarUrl}
        key={index}
        alt="praised-person-avatar"
      />
    );
    return <div>{list}</div>;
  }
}
