"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var passport = require("passport");
var ExtractJwt = require("passport-jwt").ExtractJwt;
var JwtStrategy = require("passport-jwt").Strategy;
var SECRET = "shadow";
var jwtOptions = {
    jwtFromRequest: ExtractJwt.fromHeader("authorization"),
    secretOrKey: SECRET
};
var jwtAuth = new JwtStrategy(jwtOptions, function (payload, done) {
    if (payload.username)
        done(null, true);
    else
        done(null, false);
});
passport.use(jwtAuth);
var requireJWTAuth = passport.authenticate("jwt", { session: false });
exports.default = requireJWTAuth;
