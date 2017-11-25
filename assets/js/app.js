import "phoenix_html";
import socket from "./socket";

import React from 'react';
import ReactDOM from 'react-dom';
import Header from './components/header'

function renderHeader() {
  let div = document.getElementById('header');
  ReactDOM.render(<Header />, div);
}

function start() {
  renderHeader();
  let html = <h1>Hello, World</h1>;
  let main = document.getElementById('main');

  ReactDOM.render(html, main);
}

$(start);
