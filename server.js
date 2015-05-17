var koa = require('koa');
var app = koa();
var exec = require('child_process').exec;
var routing = require('koa-routing');

app.use(routing(app));

function getSnapshot(callback){
	console.log("query", this.query);

	if(!this.query) {
		callback("url, width, and height query parameters are required!", null);
	}

	if(!this.query.url) {
		callback("'url' query parameter is required!", null);
	}
	
	if(!this.query.width) {
		callback("'width' query parameter is required!", null);
	}
	
	if(!this.query.height) {
		callback("'height' query parameter is required!", null);
	}
    
    exec("phantomjs capture.js " + this.query.url + " " + this.query.width + " " + this.query.width, function (error, stdout, stderr) {
    	callback(null, "data:image/png;base64," + stdout);
    });
}

// response
app.route('/')
  .get(function * (next) {
  	console.log("query", this.query);
  	this.body = yield getSnapshot;

  })


app.listen(3000);
