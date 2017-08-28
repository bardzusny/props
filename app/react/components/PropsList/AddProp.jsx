import React, { Component, PropTypes } from 'react';
import cx from 'classnames';
import Select from 'react-select';
import 'react-select/dist/react-select.css';
import { forIn } from 'lodash';
import AvatarOption from './AvatarOption';
import UserAvatar from './UserAvatar';
import styles from './style.css';

class AddProp extends Component {
  constructor(props) {
    super(props);
    this.state = {
      praisedUsers: [],
      propText: '',
      isFormValid: true,
    };

    this.handleSelectChange = this.handleSelectChange.bind(this);
    this.handlePropText = this.handlePropText.bind(this);
    this.handlePropSubmit = this.handlePropSubmit.bind(this);
    this.clearValidation = this.clearValidation.bind(this);
  }

  getOptions() {
    const options = [];
    const data = this.props.users;
    const isCurrentUser = id => (
      this.props.currentUser.id === id
    );

    forIn(data, (option) => {
      options.push({
        label: option.name,
        value: option.id,
        avatar: option.avatar_url,
        disabled: isCurrentUser(option.id),
      });
    });
    return options;
  }

  getValidationMessage() {
    return (
      !this.state.isFormValid &&
      <div
        className="alert alert-danger text-center"
        role="alert"
        data-test="validation-message"
      >
        Praised user(s) and  description are required.
      </div>
    );
  }

  handlePropText(event) {
    this.setState({ propText: event.target.value });
    this.clearValidation();
  }

  handlePropSubmit(e) {
    e.preventDefault();
    const propser = this.props.currentUser.id;
    const users = this.state.praisedUsers.map(u => u.value).join(',');
    const body = this.state.propText;

    if (!users.length || !body.trim()) {
      this.setState({ isFormValid: false });
      return;
    }

    this.props.onPropSubmit(propser, users, body);
    this.setState({
      praisedUsers: [],
      propText: '',
    });
  }

  handleSelectChange(praisedUsers) {
    this.setState({ praisedUsers });
    this.clearValidation();
  }

  clearValidation() {
    this.setState({ isFormValid: true });
  }

  render() {
    return (
      <div className="row">
        <div className="col-xs-12">
          <div
            className={cx(
              'jumbotron',
              styles.grid,
            )}
          >
            <div className="selected-users">
              {
                this.state.praisedUsers.map(user => (
                  <UserAvatar key={user.value} avatarPath={user.avatar} />
                ))
              }
            </div>
            <form>
              <div className="form-group">
                <Select
                  multi
                  disabled={false}
                  value={this.state.praisedUsers}
                  placeholder="Whom do you want to give a prop to?"
                  options={this.getOptions()}
                  onChange={this.handleSelectChange}
                  optionComponent={AvatarOption}
                />
              </div>
              <div className="form-group">
                <textarea
                  rows="2"
                  placeholder="What do you want to thank for?"
                  className="form-control"
                  type="text"
                  value={this.state.propText}
                  onChange={this.handlePropText}
                />
              </div>
              {this.getValidationMessage()}
              <div className="pull-right">
                <button
                  data-test="submit"
                  className="form-button btn btn-primary"
                  onClick={this.handlePropSubmit}
                >
                  Prop!
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
}

AddProp.propTypes = {
  users: PropTypes.objectOf(PropTypes.object),
  currentUser: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    email: PropTypes.string,
    avatar_url: PropTypes.string,
  }),
  onPropSubmit: PropTypes.func,
};

export default AddProp;
