"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var mongoose = require("mongoose");
var db = /** @class */ (function () {
    function db() {
        this.connect();
    }
    db.prototype.connect = function () {
        console.log("connecting");
        var uri = "mongodb+srv://lullaby:Lay@22331@cluster0.80apm.mongodb.net/lullaby?retryWrites=true&w=majority";
        mongoose.connect(uri, { useUnifiedTopology: true, useNewUrlParser: true, useFindAndModify: false, useCreateIndex: true });
        var connection = mongoose.connection;
        connection.once("open", function () {
            console.log("MongoDB database connection established successfully");
        });
    };
    return db;
}());
exports.default = db;
