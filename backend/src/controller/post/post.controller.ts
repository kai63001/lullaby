import express, {Application, Request, Response, NextFunction} from 'express';
import authRequest from '../../interfaces/auth.ext';
const Posts = require('../../models/posts.model')
const jwt = require("jwt-simple");
const mongoose = require("mongoose");

class UsersController {

  public router: express.Router = express.Router();
  public path: string = '/';

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
    this.router.get('/post',authRequest, this.getAllPost);
    this.router.post('/post',authRequest, this.insertPost);
    this.router.get('/post/like/:id',authRequest, this.likePost);
  }

  private async getAllPost( req: Request, res: Response, next: NextFunction) {
    const apr = await Posts
    .aggregate([
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
          nowImage: 0
        },
      },
    ])
    .exec();
    res.json(apr);
  }

  private insertPost( req: Request, res: Response, next: NextFunction):void {
    const usertoken = req.headers.authorization
    const decoded = jwt.decode(usertoken, "shadow")
    Posts.insertMany([
      {
        title:req.body.title,
        userId: mongoose.Types.ObjectId(decoded.id),
        date: Date.now()
      }
    ], (_err: any)=> {
          if(_err) {
              console.log(_err)
          }else{
              res.send("post success")
          }
      })
  }

  private likePost(req: Request,res:Response):void {
    res.send(req.params.id)
  }

}

export default UsersController;