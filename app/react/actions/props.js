import fetch from 'isomorphic-fetch';
import {
  RECEIVE_PROPS,
  REQUEST_PROPS_PAGE,
  RECEIVE_PROPS_PAGE } from '../constants/props';

export const receiveProps = props => ({
  type: RECEIVE_PROPS,
  payload: {
    props: props.props,
  },
});

export const requestPropsPage = () => ({
  type: REQUEST_PROPS_PAGE,
});

export const receivePropsPage = props => ({
  type: RECEIVE_PROPS_PAGE,
  payload: {
    hasPreviousPage: props.meta.current_page > 1,
    hasNextPage: props.meta.current_page < props.meta.total_pages,
    currentPage: props.meta.current_page,
  },
});

export const fetchProps = (page = 1, showLoader = true) => (dispatch) => {
  if (showLoader) dispatch(requestPropsPage());

  return fetch(`/api/v1/props?page=${page}`, {
    credentials: 'same-origin',
  })
  .then(req => req.json())
  .then((json) => {
    dispatch(receiveProps(json));
    dispatch(receivePropsPage(json));
  });
};

export const giveProp = (propserId, userIds, body) => dispatch => (
  fetch('api/v1/props', {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify({
      propser_id: propserId,
      user_ids: userIds,
      body,
    }),
  })
  .then(() => {
    dispatch(fetchProps());
  })
);

export const upvoteProp = id => (dispatch, getState) => (
  fetch(`api/v1/props/${id}/upvotes`, {
    method: 'POST',
    credentials: 'same-origin',
  })
  .then(() => {
    const { propsPagination } = getState();
    dispatch(fetchProps(propsPagination.currentPage, false));
  })
);

export const downvoteProp = id => (dispatch, getState) => (
  fetch(`api/v1/props/${id}/undo_upvotes`, {
    method: 'DELETE',
    credentials: 'same-origin',
  })
  .then(() => {
    const { propsPagination } = getState();
    dispatch(fetchProps(propsPagination.currentPage, false));
  })
);
