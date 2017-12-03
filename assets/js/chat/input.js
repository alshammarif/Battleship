import React from 'react';

export default class Input extends React.Component {
  render() {
    return(
      <div class="row">
        <div class="col-lg-6">
          <div class="input-group">
            <input type="text" class="form-control" placeholder="Enter message..." aria-label="message...">
            <span class="input-group-btn">
            <button class="btn btn-secondary" type="button">Enter</button>
            </span>
            </div>
            </div>
      </div>
    );
  }
}
