export const noopEvent = {
  preventDefault: () => {},
  stopPropagation: () => {},
};

export const createEventTarget = value => (
  {
    target: {
      value,
    },
  }
);
