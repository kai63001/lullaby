"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var users = new Schema({
    username: {
        type: String
    },
    password: {
        type: String
    },
    avatar: {
        type: { type: String, default: 'assets/images/avatars/monster.png' }
    }
});
module.exports = mongoose.model("users", users);
