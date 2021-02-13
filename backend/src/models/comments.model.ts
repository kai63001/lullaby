export {};
const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const likes = new Schema({
  postId: {
    type: Object,
  },
  comments: [
    {
      userId : Object,
      comment : String
    },
  ],
});

module.exports = mongoose.model("likes", likes);
