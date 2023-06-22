/* eslint-disable no-underscore-dangle */
import {DOMWidgetView} from "@jupyter-widgets/base";

// Import the CSS
import "../style/index.css";

export class MyWidgetView extends DOMWidgetView {
  render() {
    this.model.on("msg:custom", this._handle_message, this);
  }

  _render() {
    // TODO
  }

  _handle_message(msg) {
    this._render();
  }
}
