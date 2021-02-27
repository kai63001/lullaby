"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var comments = new Schema({
    postId: {
        type: Object,
    },
    userId: {
        type: Object,
    },
    comment: {
        type: String
    },
    date: {
        type: Number
    }
    // comments: [
    //   {
    //     userId: Object,
    //     comment: String,
    //     date: Number
    //   },
    // ],
});
module.exports = mongoose.model("comments", comments);
