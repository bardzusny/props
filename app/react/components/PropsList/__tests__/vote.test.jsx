/* eslint-disable no-unused-expressions */
import React from 'react';
import chaiEnzyme from 'chai-enzyme';
import { shallow } from 'enzyme';
import chai, { expect } from 'chai';
import Vote from '../Vote';

jest.unmock('../Vote');
chai.use(chaiEnzyme());


describe('<Vote />', () => {
  const onUpvote = jest.fn();
  const undoUpvote = jest.fn();
  const defaultProps = {
    onUpvote,
    upvotesCount: 10,
    isUpvotePossible: true,
    isUndoUpvotePossible: false,
    upVoting: false,
    undoUpvote,
  };

  const component = shallow(
    <Vote {...defaultProps} />
  );

  const componentWithoutRating = shallow(
    <Vote {...defaultProps} upvotesCount={0} />
  );

  const componentWithDisabledVoting = shallow(
    <Vote {...defaultProps} isUpvotePossible={false} />
  );

  const componentWithUndoButton = shallow(
    <Vote {...defaultProps} isUpvotePossible={false} isUndoUpvotePossible />
  );

  it('renders', () => {
    expect(component).to.exist;
  });

  describe('rating button', () => {
    describe('when rating is greater 0', () => {
      const element = component.find('[data-test="rating"]');
      it('displays current rating', () => {
        expect(element).to.have.exist;
      });
    });

    describe('when rating is 0', () => {
      const element = componentWithoutRating.find('[data-test="rating"]');
      it('is not visible', () => {
        expect(element).to.not.exist;
      });
    });
  });

  describe('upvote button', () => {
    describe('when isUpvotePossible flag is set', () => {
      it('is visible', () => {
        const element = componentWithoutRating.find('[data-test="upvote"]');
        expect(element).to.exist;
      });
    });

    it('runs passed onUpvote handler when clicked', () => {
      componentWithoutRating.find('[data-test="upvote"]').simulate('click');
      expect(onUpvote.mock.calls.length).equal(1);
    });
  });

  describe('when isUpvotePossible flag is not set', () => {
    it('is not visible', () => {
      const element = componentWithDisabledVoting.find('[data-test="upvote"]');
      expect(element).to.not.exist;
    });
  });

  describe('undo upvote button', () => {
    describe('when isUpvotePossible flag is not set', () => {
      it('is visible', () => {
        const element = componentWithUndoButton.find('[data-test="undo-upvote"]');
        expect(element).to.exist;
      });

      it('runs passed undoUpvote handler when clicked', () => {
        componentWithUndoButton.find('[data-test="undo-upvote"]').simulate('click');
        expect(undoUpvote.mock.calls.length).equal(1);
      });
    });

    describe('when isUpvotePossible flag is set', () => {
      it('is not visible', () => {
        const element = component.find('[data-test="undo-upvote"]');
        expect(element).to.not.exist;
      });
    });
  });
});
