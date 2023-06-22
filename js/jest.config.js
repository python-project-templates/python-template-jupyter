
const esModules = ["@jupyter", "@jupyterlab", "@jupyter-widgets", "lib0", "y-protocols", "dagre-d3-es", "d3", "internmap", "delaunator", "robust-predicates", "lodash-es"].join("|");

module.exports = {
  moduleDirectories: ["node_modules", "src", "tests"],
  moduleNameMapper: {
    "\\.(css|less|sass|scss)$": "<rootDir>/tests/styleMock.js",
    "\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$": "<rootDir>/tests/fileMock.js",
  },
  reporters: [ "default", "jest-junit" ],
  testEnvironment: "jsdom",
  transform: {
    "^.+\\.jsx?$": "babel-jest",
    ".+\\.(css|styl|less|sass|scss)$": "jest-transform-css",
  },
  transformIgnorePatterns: [`/node_modules/(?!(${esModules}))`],
};
