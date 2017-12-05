import React from 'react';

import Square from './square';

export default class BoardRender extends React.Component {
  guessHandler(x,y) {

  }

  shipPlacementHandler(x,y) {

  }

  clickHandler(x,y) {

  }

  getGrid() {
    let result = this.props.grid.map((row, y) => {
      let squares = row.map((sq, x) => {
        <Square onClick={this.clickHandler.bind(this, x, y)} />
      })
      return <tr key={y}>{squares}</tr>
    });
    return result;
  }

  render() {
    let rows = getGrid();
    return(
      <table>
        <tbody>
          {rows}
        </tbody>
      </table>
    );
  }
}
