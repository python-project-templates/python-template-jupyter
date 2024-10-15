import "../style/index.css";

async function activate(app) {
  // eslint-disable-next-line no-console
  console.log("JupyterLab extension python-template-jupyter is activated!");
}

const extension = {
  activate,
  autoStart: true,
  id: "python-template-jupyter",
  optional: [],
  requires: [],
};

export default extension;
export {activate as _activate};
