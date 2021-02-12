import express, { Application, Request, Response, NextFunction } from "express";
import authRequest from "../../interfaces/auth.ext";
const Posts = require("../../models/posts.model");
const Likes = require("../../models/likes.model");
const jwt = require("jwt-simple");
const mongoose = require("mongoose");

class UsersController {
  public router: express.Router = express.Router();
  public path: string = "/";

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
    this.router.get("/post", authRequest, this.getAllPost);
    this.router.post("/post", authRequest, this.insertPost);
    this.router.get("/post/like/:id", authRequest, this.likeFrist);
    this.router.get("/post/like/:id/update", authRequest, this.updateLikePost);
  }

  private async getAllPost(req: Request, res: Response, next: NextFunction) {
    const apr = await Posts.aggregate([
      {
        $lookup: {
          from: "users", // collection name in db
          localField: "userId",
          foreignField: "_id",
          as: "users",
        },
      },
      {
        $lookup: {
          from: "likes", // collection name in db
          localField: "_id",
          foreignField: "postId",
          as: "likes",
        },
      },
      {
        $project: {
          "users._id": 0,
          "users.password": 0,
          "likes._id": 0,
          "likes.postId": 0,
        },
      },
      {
        $addFields: {
          nowImage: 0,
        },
      },
    ]).exec();
    res.json(apr);
  }

  private insertPost(req: Request, res: Response, next: NextFunction): void {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    Posts.insertMany(
      [
        {
          title: req.body.title,
          userId: mongoose.Types.ObjectId(decoded.id),
          date: Date.now(),
        },
      ],
      (_err: any) => {
        if (_err) {
          console.log(_err);
        } else {
          res.send("post success");
        }
      }
    );
  }

  private likeFrist(req: Request, res: Response, next: NextFunction): void {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    Likes.insertMany(
      [
        {
          postId: mongoose.Types.ObjectId(req.params.id),
          users: [mongoose.Types.ObjectId(decoded.id)],
        },
      ],
      (_err: any) => {
        if (_err) {
          console.log(_err);
        } else {
          res.send("Like success");
        }
      }
    );
  }

  private updateLikePost(req: Request, res: Response): void {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    Likes.findOneAndUpdate(
      { postId: mongoose.Types.ObjectId(req.params.id) },
      { $push: { users: [mongoose.Types.ObjectId(decoded.id)] } },
      function (error: any, success: any) {
        if (error) {
          res.send(error);
        } else {
          res.send("update like success");
        }
      }
    );
  }
}

export default UsersController;
