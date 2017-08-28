/* eslint-disable no-unused-expressions */
import React from 'react';
import chaiEnzyme from 'chai-enzyme';
import { shallow } from 'enzyme';
import chai, { expect } from 'chai';
import AddProp from '../AddProp';
import { noopEvent } from '../../../utils/shared';

jest.unmock('../AddProp');
chai.use(chaiEnzyme());

const handleSubmit = jest.fn();

const component = shallow(
  <AddProp
    users={{}}
    currentUser={{}}
    onPropSubmit={handleSubmit}
  />
);

describe('<AddProp />', () => {
  it('renders', () => {
    expect(component).to.exist;
  });

  it('shows validation message', () => {
    component.find('[data-test="submit"]').simulate('click', noopEvent);
    expect(component.find('[data-test="validation-message"]')).to.exist;
  });

  it('submits prop', () => {
    component.setState({ praisedUsers: [{ value: 1 }], propText: 'Test props' });
    component.find('[data-test="submit"]').simulate('click', noopEvent);
    expect(handleSubmit.mock.calls.length).equal(1);
  });
});
