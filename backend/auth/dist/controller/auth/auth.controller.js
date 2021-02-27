"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = __importDefault(require("express"));
var login_middleware_1 = __importDefault(require("../../middleware/auth/login.middleware"));
var register_middleware_1 = __importDefault(require("../../middleware/auth/register.middleware"));
var jwt = require("jwt-simple");
var auth_ext_1 = __importDefault(require("../../interfaces/auth.ext"));
var Auth = /** @class */ (function () {
    function Auth() {
        this.router = express_1.default.Router();
        this.path = '/auth';
        this.initializeRoutes();
    }
    Auth.prototype.initializeRoutes = function () {
        this.router.post(this.path + "/login", login_middleware_1.default, this.login);
        this.router.get(this.path + "/logout", auth_ext_1.default, this.logout);
        this.router.post(this.path + "/register", register_middleware_1.default, this.register);
    };
    Auth.prototype.login = function (req, res, next) {
        var payload = {
            id: req.userId,
            username: req.body.username,
            iat: new Date().getTime()
        };
        res.send(jwt.encode(payload, "shadow"));
    };
    Auth.prototype.register = function (req, res) {
        res.send("register success");
    };
    Auth.prototype.logout = function (req, res, next) {
        res.send("logout");
    };
    return Auth;
}());
exports.default = Auth;
