var koa = require('koa'),
	app = koa(),
	exec = require('child_process').exec,
	routing = require('koa-routing'),
	serve = require("koa-static");

app.use(serve(__dirname + "/preview"));
app.use(routing(app));

function getSnapshot(callback){

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
    	if(error) console.log("Error:", error);
    	callback(null, "data:image/png;base64," + stdout);
    });

}

// response
app.route('/query')
  .get(function * (next) {
  	console.log("query", this.query);
  	this.body = yield getSnapshot;

  });

app.listen(process.env.PORT || 3000);

process.on('uncaughtException', function(err) {
    // handle the error safely
    console.log(err)
})
