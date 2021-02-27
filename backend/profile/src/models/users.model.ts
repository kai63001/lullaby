export {};
const mongoose = require("mongoose");

const Schema = mongoose.Schema;

let users = new Schema(
  {
    username: {
      type: String
    },
    password: {
      type: String
    },
    avatar: {
      type : {type: String , default: 'assets/images/avatars/monster.png'}
    }

  }
);

module.exports = mongoose.model("users", users);