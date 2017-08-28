import fetch from 'isomorphic-fetch';

import {
  REQUEST_USER_PROPS,
  RECEIVE_USER_PROPS,
  REQUEST_USER_GIVEN_PROPS,
  RECEIVE_USER_GIVEN_PROPS,
  RECEIVE_USER,
  REQUEST_USER,
  RECEIVE_USERS,
  REQUEST_USERS,
} from '../constants/action-types';

function receiveUserProps(json) {
  return {
    type: RECEIVE_USER_PROPS,
    props: json,
  };
}

function requestUserProps() {
  return {
    type: REQUEST_USER_PROPS,
  };
}

function receiveUserGivenProps(json) {
  return {
    type: RECEIVE_USER_GIVEN_PROPS,
    props: json,
  };
}

function requestUserGivenProps() {
  return {
    type: REQUEST_USER_GIVEN_PROPS,
  };
}

function receiveUser(json) {
  return {
    type: RECEIVE_USER,
    user: json,
  };
}

function requestUser() {
  return {
    type: REQUEST_USER,
  };
}

function receiveUsers(json) {
  return {
    type: RECEIVE_USERS,
    users: json,
  };
}

function requestUsers() {
  return {
    type: REQUEST_USERS,
  };
}

export function fetchUserProps(userId) {
  return (dispatch) => {
    dispatch(requestUserProps());
    return fetch(`/api/v1/props?user_id=${userId}`, {
      credentials: 'same-origin',
    })
    .then(req => req.json())
    .then(json => dispatch(receiveUserProps(json)));
  };
}

export function fetchUserGivenProps(userId) {
  return (dispatch) => {
    dispatch(requestUserGivenProps());
    return fetch(`/api/v1/props?propser_id=${userId}`, {
      credentials: 'same-origin',
    })
    .then(req => req.json())
    .then(json => dispatch(receiveUserGivenProps(json)));
  };
}

export function fetchUser(userId) {
  return (dispatch) => {
    dispatch(requestUser());
    return fetch(`/api/v1/users/${userId}`, {
      credentials: 'same-origin',
    })
    .then(req => req.json())
    .then(json => dispatch(receiveUser(json)));
  };
}

export function fetchUsers() {
  return (dispatch) => {
    dispatch(requestUsers());
    return fetch('/api/v1/users', {
      credentials: 'same-origin',
    })
    .then(req => req.json())
    .then(json => dispatch(receiveUsers(json)));
  };
}
