import React, { PropTypes, Component } from 'react';
import { connect } from 'react-redux';
import Announcement from '../../components/announcement';
import Loader from '../../components//shared/loader';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoading: true,
      total: 0,
    };
  }

  componentDidMount() {
    fetch('/api/v1/props/total', {
      credentials: 'same-origin',
    })
    .then(req => req.json())
    .then((json) => {
      this.setState({
        isLoading: false,
        total: json,
      });
    });
  }

  render() {
    return (
      <div>
        {
          this.state.isLoading
          ? <Loader />
          : (
            <div>
              <Announcement propsCount={this.state.total} />
              {this.props.children}
            </div>
          )
        }
      </div>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  currentPath: ownProps.location.pathname,
});

App.propTypes = {
  children: PropTypes.node,
};

export default connect(mapStateToProps)(App);
