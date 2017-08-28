import React, { PropTypes } from 'react';

export default class NavbarLink extends React.Component {
  static get propTypes() {
    return {
      link: PropTypes.shape({
        url: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
      }),
      onLinkClick: PropTypes.func,
      isRoutable: PropTypes.bool.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }


  handleClick(e) {
    if (this.props.isRoutable) {
      e.preventDefault();
      this.props.onLinkClick(this.props.link.url);
    }
  }

  renderLinks() {
    const { link } = this.props;
    return (
      <li key={link.url}>
        <a href={link.url} onClick={this.handleClick}>
          {link.name}
        </a>
      </li>
    );
  }

  render() {
    return (
      <ul className="nav navbar-nav">
        {this.renderLinks()}
      </ul>
    );
  }
}
