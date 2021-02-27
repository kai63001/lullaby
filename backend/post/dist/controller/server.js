"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var bodyParser = require("body-parser");
var express_1 = __importDefault(require("express"));
var Users = require("../models/users.model");
var jwt = require("jwt-simple");
var passport = require("passport");
var ExtractJwt = require("passport-jwt").ExtractJwt;
var JwtStrategy = require("passport-jwt").Strategy;
var SECRET = "shadow";
var jwtOptions = {
    jwtFromRequest: ExtractJwt.fromHeader("authorization"),
    secretOrKey: SECRET
};
var jwtAuth = new JwtStrategy(jwtOptions, function (payload, done) {
    if (payload.sub)
        done(null, true);
    else
        done(null, false);
});
passport.use(jwtAuth);
var requireJWTAuth = passport.authenticate("jwt", { session: false });
var Server = /** @class */ (function () {
    function Server(port) {
        this.app = express_1.default();
        this.port = port;
        this.app.use(bodyParser.json());
        this.config();
        this.run();
    }
    Server.prototype.config = function () {
        var loginMiddleWare = function (req, res, next) {
            Users.findOne({ username: req.body.username, password: req.body.password }, function (err, result) {
                if (err) {
                    res.send(err);
                }
                else if (!result) {
                    res.json({
                        "status": "not found"
                    });
                }
                else {
                    next();
                }
            });
        };
        this.app.post("/login", loginMiddleWare, function (req, res) {
            var payload = {
                sub: req.body.username,
                iat: new Date().getTime()
            };
            res.send(jwt.encode(payload, SECRET));
        });
        this.app.post("/register", function (req, res) {
        });
        this.app.get("/", requireJWTAuth, function (req, res, next) {
            res.send("ยอดเงินคงเหลือ 50");
            ;
        });
        this.app.get('/logout', requireJWTAuth, function (req, res, next) {
            var usertoken = req.headers.authorization;
            jwt.destroy(usertoken);
            res.send('logout');
        });
    };
    Server.prototype.run = function () {
        var _this = this;
        this.app.listen(this.port, function () {
            console.log("server start on port : " + _this.port);
        });
    };
    return Server;
}());
exports.default = Server;
