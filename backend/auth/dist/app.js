"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var bodyParser = require("body-parser");
var express_1 = __importDefault(require("express"));
var db_1 = __importDefault(require("./connection/db"));
var cors = require('cors');
var App = /** @class */ (function () {
    function App(controllers) {
        this.app = express_1.default();
        this.connectToTheDatabase();
        this.initializeMiddlewares();
        this.initializeControllers(controllers);
    }
    App.prototype.listen = function () {
        this.app.listen(process.env.PORT || 3000, function () {
            console.log("App listening on the port " + (process.env.PORT || 3000));
        });
    };
    App.prototype.initializeMiddlewares = function () {
        this.app.use(bodyParser.json());
    };
    App.prototype.initializeControllers = function (controllers) {
        var _this = this;
        controllers.forEach(function (controller) {
            _this.app.use("/", controller.router);
        });
    };
    App.prototype.connectToTheDatabase = function () {
        this.app.use(cors());
        var Connect = new db_1.default();
    };
    return App;
}());
exports.default = App;
