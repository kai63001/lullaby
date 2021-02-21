import express, { Application, Request, Response, NextFunction } from "express";
import authRequest from "../../interfaces/auth.ext";
const Posts = require("../../models/posts.model");
const Likes = require("../../models/likes.model");
const Comments = require("../../models/comments.model");
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
    this.router.delete("/post/:id", authRequest, this.deletePost);
    this.router.get("/post/like/:id/update", authRequest, this.updateLikePost);
    this.router.get("/post/unlike/:id", authRequest, this.disLike);
    this.router.get("/post/:id/comment", authRequest, this.commentList);
    this.router.post("/post/:id/comment", authRequest, this.comment);
    this.router.post("/post/:id/comment/add", authRequest, this.commentAdd);
    this.router.delete(
      "/post/:id/comment/delete",
      authRequest,
      this.commentDelete
    );
  }

  private async getAllPost(req: Request, res: Response, next: NextFunction) {
    const perPage: number = parseInt(req.query.limit as string) || 8;
    const page: string = (req.query.page as string) || Date.now().toString();

    const apr = await Posts.aggregate([
      { $match: { date: { $lte: parseInt(page) - 1 } } },
      { $sort: { date: -1 } },
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
        $lookup: {
          from: "comments", // collection name in db
          localField: "_id",
          foreignField: "postId",
          as: "comments",
        },
      },
      {
        $project: {
          "users._id": 0,
          "users.password": 0,
          "likes._id": 0,
          "likes.postId": 0,
          "comments.postId": 0,
          "comments._id": 0,
        },
      },
      {
        $addFields: {
          haveLike: { $size: "$likes" },
          haveComment: { $size: "$comments" },
        },
      },
      {
        $facet: {
          data: [{ $limit: perPage }],
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
          feel: req.body.feel,
          feelColor : req.body.feelColor,
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
    Likes.updateOne(
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

  private disLike(req: Request, res: Response): void {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    Likes.updateOne(
      { postId: mongoose.Types.ObjectId(req.params.id) },
      { $pullAll: { users: [mongoose.Types.ObjectId(decoded.id)] } },
      function (error: any, success: any) {
        if (error) {
          res.send(error);
        } else {
          res.send("unlike success");
        }
      }
    );
  }

  private comment(req: Request, res: Response): void {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    Comments.insertMany(
      [
        {
          postId: mongoose.Types.ObjectId(req.params.id),
          userId: mongoose.Types.ObjectId(decoded.id),
          comment: req.body.comment,
          date: Date.now()
          // comments: [
          //   {
          //     userId: mongoose.Types.ObjectId(decoded.id),
          //     comment: req.body.comment,
          //     date: Date.now()
          //   },
          // ],
        },
      ],
      (_err: any) => {
        if (_err) {
          console.log(_err);
        } else {
          res.send("comment success");
        }
      }
    );
  }

  private commentAdd(req: Request, res: Response): void {
    // const usertoken = req.headers.authorization;
    // const decoded = jwt.decode(usertoken, "shadow");
    // Comments.updateOne(
    //   { postId: mongoose.Types.ObjectId(req.params.id) },
    //   {
    //     $push: {
    //       comments: [
    //         {
    //           userId: mongoose.Types.ObjectId(decoded.id),
    //           comment: req.body.comment,
    //           date: Date.now()
    //         },
    //       ],
    //     },
    //   },
    //   function (error: any, success: any) {
    //     if (error) {
    //       res.send(error);
    //     } else {
    //       res.send("comment add success");
    //     }
    //   }
    // );
  }

  private commentDelete(req: Request, res: Response): void {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    Comments.deleteOne({ _id: mongoose.Types.ObjectId(req.params.id),userId: mongoose.Types.ObjectId(decoded.id) }, function (err: any) {
      if(err) {
        res.send("err")
      }else{
        res.send("delete success");
      }
    });
  }
  
  private async commentList(req:Request, res:Response) {
    const apr = await Comments.aggregate([
      { $match: { postId: { $eq:  mongoose.Types.ObjectId(req.params.id) } } },
      { $sort: { date: -1 } },
      {
        $lookup: {
          from: "users", // collection name in db
          localField: "userId",
          foreignField: "_id",
          as: "users",
        },
      },
      {
        $project: {
          "users._id": 0,
          "users.password": 0,
        },
      },
    ]).exec();
    res.json(apr);
  }

  private async deletePost(req:Request, res:Response) {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    Posts.deleteOne({ _id: mongoose.Types.ObjectId(req.params.id),userId: mongoose.Types.ObjectId(decoded.id) }, function (err: any) {
      if(err) {
        res.send("err")
      }else{
        res.send("delete posts success");
      }
    });
  }

}

export default UsersController;
