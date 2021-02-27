"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var likes = new Schema({
    postId: {
        type: Object
    },
    users: [
        {
            type: Object
        }
    ]
});
module.exports = mongoose.model("likes", likes);
