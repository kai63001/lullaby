export {};
const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const posts = new Schema(
  {
    title: {
      type: String,
    },
    userId: {
      type: Object,
    },
    feel : {
        type: String, default: 'sad'
    },
    date: {
      type: Number,
    }
  }
);


module.exports = mongoose.model("posts", posts);