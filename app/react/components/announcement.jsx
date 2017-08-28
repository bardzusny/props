import React, { PropTypes } from 'react';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';

export default class Announcement extends React.Component {
  static get propTypes() {
    return {
      propsCount: PropTypes.number.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = { animated: false };
  }

  componentDidMount() {
    setTimeout(() => {
      this.setState({ animated: true });
    }, 2000);
  }

  renderCounter() {
    if (this.state.animated) { return null; }

    return (
      <div className="announcement-screen">
        <p className="announcement-screen__fancy-text animated pulse">
          We have
          <strong> {this.props.propsCount} </strong>
          props so far!
        </p>
      </div>
    );
  }

  render() {
    return (
      <ReactCSSTransitionGroup
        transitionName="announcement"
        transitionAppear
        transitionAppearTimeout={500}
        transitionLeave
        transitionLeaveTimeout={1000}
        transitionEnter={false}
      >
        {this.renderCounter()}
      </ReactCSSTransitionGroup>
    );
  }
}
