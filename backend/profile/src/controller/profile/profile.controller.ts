
import express, { Application, Request, Response, NextFunction } from "express";
import authRequest from "../../interfaces/auth.ext";
const Posts = require("../../models/posts.model");
const Likes = require("../../models/likes.model");
const Comments = require("../../models/comments.model");
const jwt = require("jwt-simple");
const mongoose = require("mongoose");

class PostsController {
  public router: express.Router = express.Router();
  public path: string = "/";

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
      
  }

}

export default PostsController;
