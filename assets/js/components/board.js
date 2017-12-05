import React from 'react';

import BoardRender from './boardrender';

export default class Board extends React.Component {
  renderSizes(sizes) {
    return sizes.map((s, i) =>  <li id={i} className="list-group-item">{s}</li>)
  }

  render() {
    return(
      <div className= "row">
        <div className="col-md-4">
          <div className="card" style="width: 20rem;">
            <div className="card-body">
              <h4 className="card-title">Your Side</h4>
              <p className="card-text">Ship sizes are below</p>
            </div>
            <ul classNam="list-group list-group-flush">
              {this.renderSizes(this.props.player.unplaced)}
            </ul>
          </div>
        </div>
        <div className="col-md-6">
          <BoardRender
            willplace={this.props.board.ready}
            willguess={false}
            unplaced={this.props.player.unplaced}
            placed={this.props.player.placed}
            channel={this.props.channel}
          />
        </div>
      </div>
    );
  }

}
