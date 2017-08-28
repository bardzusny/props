import React, { PropTypes } from 'react';
import NavbarLink from './navbar-link';
import NavbarSettings from './navbar-settings';
import * as routerLinks from '../../constants/router-links';

export default class Navbar extends React.Component {
  static get propTypes() {
    return {
      isOnAppPage: PropTypes.bool.isRequired,
      user: PropTypes.object,
      userSignedIn: PropTypes.bool.isRequired,
      handleLinkClicked: PropTypes.func.isRequired,
      fetchInitialData: PropTypes.func.isRequired,
      currentOrganisation: PropTypes.string,
    };
  }

  componentWillMount() {
    if (!this.props.userSignedIn) return;
    this.props.fetchInitialData();
  }

  get links() {
    if (!this.props.userSignedIn) {
      return null;
    }

    if (this.props.isOnAppPage) {
      return {
        isRoutable: true,
        links: routerLinks.ROUTER_APP_LINKS,
      };
    }

    return {
      isRoutable: false,
      links: routerLinks.ROUTER_SETTINGS_LINKS,
    };
  }

  get user() {
    return this.props.user || {};
  }

  render() {
    const getNavbarLinks = (linksObject) => {
      if (linksObject) {
        return linksObject.links.map(link => (
          <NavbarLink
            key={link.url}
            isRoutable={linksObject.isRoutable}
            link={link}
            onLinkClick={this.props.handleLinkClicked}
          />
        ));
      }
      return null;
    };

    const handleLogoClick = (e) => {
      if (this.props.isOnAppPage) {
        e.preventDefault();
        this.props.fetchInitialData();
        this.props.handleLinkClicked('/app');
      }
    };

    return (
      <div className="nav navbar navbar-default navbar-static-top">
        <div className="container">
          <div className="navbar-header">
            <button
              className="navbar-toggle"
              data-target=".navbar-collapse"
              data-toggle="collapse"
              type="button"
            >
              <span className="sr-only">Toggle navigation</span>
              <span className="icon-bar" />
              <span className="icon-bar" />
              <span className="icon-bar" />
            </button>
            <a className="navbar-logo" href="/app" onClick={handleLogoClick}>Props App</a>
          </div>

          <div className="collapse navbar-collapse">
            <ul className="nav navbar-nav">
              {getNavbarLinks(this.links)}
            </ul>
            <NavbarSettings
              user={this.user}
              userSignedIn={this.props.userSignedIn}
              currentOrganisation={this.props.currentOrganisation}
            />
          </div>
        </div>
      </div>
    );
  }
}
