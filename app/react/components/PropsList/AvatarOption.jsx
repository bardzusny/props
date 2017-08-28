import React, { PropTypes } from 'react';
import styles from './style.css';

const AvatarOption = ({
  children,
  option,
  className,
  onSelect,
  onFocus,
  isFocused,
  isDisabled,
}) => {
  const handleMouseDown = (event) => {
    event.preventDefault();
    event.stopPropagation();
    if (isDisabled) return;
    onSelect(option, event);
  };

  const handleMouseMove = (event) => {
    if (isFocused) return;
    onFocus(option, event);
  };

  const handleMouseEnter = (event) => {
    onFocus(option, event);
  };

  return (
    <div
      className={className}
      onMouseDown={handleMouseDown}
      onMouseEnter={handleMouseEnter}
      onMouseMove={handleMouseMove}
    >
      <img src={option.avatar} alt="avatar" className={styles['option-avatar']} />
      {children}
    </div>
  );
};

AvatarOption.propTypes = {
  children: PropTypes.node,
  option: PropTypes.shape({
    label: PropTypes.string,
    value: PropTypes.number,
    avatar: PropTypes.string,
    disabled: PropTypes.bool,
  }),
  className: PropTypes.string,
  onSelect: PropTypes.func,
  onFocus: PropTypes.func,
  isFocused: PropTypes.bool,
  isDisabled: PropTypes.bool,
};

export default AvatarOption;
