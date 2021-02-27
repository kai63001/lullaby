"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var posts = new Schema({
    title: {
        type: String,
    },
    userId: {
        type: Object,
    },
    feel: {
        type: String, default: 'sad'
    },
    feelColor: {
        type: Number, default: 0xff854cfd
    },
    date: {
        type: Number,
    }
});
module.exports = mongoose.model("posts", posts);
