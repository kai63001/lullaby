export {};
const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const posts = new Schema(
  {
    title: {
      type: String,
    },
    userId: {
      type: String,
    },
    date: {
      type: Number,
    }
  }
);

module.exports = mongoose.model("posts", posts);