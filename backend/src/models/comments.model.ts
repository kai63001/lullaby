export {};
const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const comments = new Schema({
  postId: {
    type: Object,
  },
  comments: [
    {
      userId: Object,
      comment: String,
      date: Number
    },
  ],
});

module.exports = mongoose.model("comments", comments);
