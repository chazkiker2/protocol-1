import { PayloadAction } from '@reduxjs/toolkit';

import WebpageTracker, { Location } from '../../lib/WebpageTracker';
import type { State } from '../state';
import { initialState } from '../state';
import { ADD_WEBPAGE } from '../actionTypes';

const reducers = (
  state: State = initialState,
  action: PayloadAction<Location>
) => {
  switch (action.type) {
    case ADD_WEBPAGE:
      return {
        ...state,
        webpages: WebpageTracker.add(state.webpages, action.payload),
      };

    default:
      return state;
  }
};

export default reducers;
