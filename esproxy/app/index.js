
/**

Notes:

Video on SAML
https://www.youtube.com/watch?v=i8wFExDSZv0


had to do a git clone of this https://github.com/derickson/node-http-proxy
inside the node_modules folder
as well as a npm install inside that code to get dependencies
Need to package that better
the node-http-proxy is a fix off of an http-proxy library I like in from the defunct nodejitsu
HBOLab did the work to merge a pull request in a fork, so I'm just forking that to have access to it locally


Lots of the below code might have both express and http based servers.
because I want to use passport, using as much express oriented stuff as possible would be great
I'd love to find a way to have a more express native reverse proxy than carrying forward the seemingly defunct http-proxy code




*/



var db = require('./db');

var express = require('express');
var app = express();

var httpProxy = require('node-http-proxy');

var passport = require('passport');
var Strategy = require('passport-http').BasicStrategy;

var serverOne = 'http://kibana:5601';


// from https://www.elastic.co/blog/user-impersonation-with-x-pack-integrating-third-party-auth-with-kibana
//    proxy_set_header Authorization "Basic bmdpbng6c2VjcmV0cGFzc3dvcmQ="
//    proxy_set_header es-security-runas-user $http_x_forwarded_user;
function beforeProxyRequest(req, options, outgoingOptions) {
  outgoingOptions.headers = outgoingOptions.headers || { };
  outgoingOptions.headers['Authorization'] = 'Basic bmdpbng6c2VjcmV0cGFzc3dvcmQ=';
  outgoingOptions.headers['es-security-runas-user'] = req.user.username;
};


var proxy = httpProxy.createProxyServer({
	beforeProxyRequest: beforeProxyRequest
});

proxy.on('error', function(e) {
  console.log(e);
});


passport.use(new Strategy(
  function(username, password, cb) {
    db.users.findByUsername(username, function(err, user) {
      if (err) { return cb(err); }
      if (!user) { return cb(null, false); }
      if (user.password != password) { return cb(null, false); }
      return cb(null, user);
    });
  }));




app.set('port', 8080);
app.use('/', passport.authenticate('basic', { session: false }), function(req, res) {
  // res.send('Hello World!')
  proxy.web(req, res, { target: serverOne });
});
/**  ################ Start Express Server ########### */

app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});


