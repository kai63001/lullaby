export {};
const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const likes = new Schema(
  {
      postId :{
          type: Object
      },
      users : {
           type: Object
      },
  }
);

module.exports = mongoose.model("likes", likes);