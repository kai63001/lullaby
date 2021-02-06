const mongoose = require("mongoose");

const Schema = mongoose.Schema;

let employee = new Schema(
  {
    username: {
      type: String
    },
    password: {
      type: String
    }
  }
);

module.exports = mongoose.model("users", employee);