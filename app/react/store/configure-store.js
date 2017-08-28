import { createStore, applyMiddleware, compose } from 'redux';
import { routerMiddleware } from 'react-router-redux';
import { browserHistory } from 'react-router';
import thunkMiddleware from 'redux-thunk';
import rootReducer from '../reducers/index';

const applyDevTools = function applyDevTools() {
  if (process.env.NODE_ENV === 'development' && window.devToolsExtension) {
    return window.devToolsExtension();
  }
  return f => f;
};

export default function configureStore(initialState) {
  const middleware = routerMiddleware(browserHistory);

  return createStore(
    rootReducer,
    initialState,
    compose(
      applyMiddleware(thunkMiddleware, middleware),
      applyDevTools(),
    )
  );
}
