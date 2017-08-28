import React, { PropTypes } from 'react';

export default class NavbarSettings extends React.Component {
  static get propTypes() {
    return {
      user: PropTypes.shape({
        name: PropTypes.string,
        email: PropTypes.string,
      }),
      userSignedIn: PropTypes.bool.isRequired,
      currentOrganisation: PropTypes.string,
    };
  }

  renderLinks() {
    if (!this.props.userSignedIn) {
      return <li><a href="/signin">Login</a></li>;
    }

    return (
      <li className="dropdown">
        <a
          className="dropdown-toggle"
          data-toggle="dropdown"
          href="dropdown-menu"
        >
          <span>{`${this.props.currentOrganisation} -  ${this.props.user.name} (${this.props.user.email})`}</span>
          <span className="caret" />
        </a>
        <ul className="dropdown-menu" role="menu">
          <li><a href="/settings">Settings</a></li>
          <li><a href="/signout">Logout</a></li>
        </ul>
      </li>
    );
  }

  render() {
    return (
      <ul className="nav navbar-nav navbar-right">
        {this.renderLinks()}
      </ul>
    );
  }
}
