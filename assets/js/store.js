import { createStore } from 'redux';
import reducer from './reducers/rootReducer'

const state0 = {
  game: {
    id: null,
    channel: null
  },
  board: {
    ready: false,
    grid: Array(10).fill(Array(10).fill('water')),
    unplaced: [5, 4, 3, 3, 2],
    placed: []
  },
  opponent: {
    id: null,
    grid: Array(10).fill(Array(10).fill('water')),
    unplaced: [5, 4, 3, 3, 2]
  }
};

const stateStore = createStore(
  reducer,
  state0,
)

export default stateStore;
