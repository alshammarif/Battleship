import { combieReducers} from 'redux';

const board = (state={}, action) => {
  if(action.type == 'BOARD_UPDATES') {
    return action.board
  } else {
    return state
  }
};

const game = (state={}, action) => {
  if(action.type == 'GAME_UPDATE') {
    return {id: action.id, channel: action.channel}
  } else {
    return state
  }
};


const opponent = (state={}, action) => {
  if(action.type == 'GET_OPPONENT') {
    return action.opponent
  } else {
    return state
  }
};

const rootReducer = combineReducers({game, board, opponent});

export default rootReducer;
