"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Users = require("../../models/users.model");
function registerMiddleWare(req, res, next) {
    if (req.body.password != req.body.conpassword) {
        res.send("password not match");
    }
    else {
        Users.findOne({ username: req.body.username }, function (err, result) {
            if (err) {
                res.send(err);
            }
            else if (result) {
                res.send("username already exit");
            }
            else {
                Users.insertMany([{ username: req.body.username, password: req.body.password }], function (_err) {
                    if (_err) {
                        console.log(_err);
                    }
                    else {
                        next();
                    }
                });
            }
        });
    }
}
exports.default = registerMiddleWare;
