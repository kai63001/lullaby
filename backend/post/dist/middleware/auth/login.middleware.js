"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Users = require("../../models/users.model");
function loginMiddleWare(req, res, next) {
    Users.findOne({ username: req.body.username, password: req.body.password }, function (err, result) {
        if (err) {
            res.send(err);
        }
        else if (!result) {
            res.send("not found");
        }
        else {
            req.userId = result._id;
            next();
        }
    });
}
exports.default = loginMiddleWare;
