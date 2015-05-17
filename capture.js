var page = require('webpage').create();
var fs = require("fs");
var system = require('system');
var args = system.args;

page.viewportSize = {
  width: args[2],
  height: args[3]
};

page.open(args[1], function() {
  var base64 = page.renderBase64('PNG');
  fs.write("/dev/stdout", base64, "w");
  phantom.exit();
});