import express, { Application, Request, Response, NextFunction } from "express";
import authRequest from "../../interfaces/auth.ext";
const Users = require("../../models/users.model");
const jwt = require("jwt-simple");
const mongoose = require("mongoose");

class ProfileController {
  public router: express.Router = express.Router();
  public path: string = "/";

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
    this.router.get("/profile", authRequest, this.getMyProfile);
  }

  private async getMyProfile(req: Request, res: Response, next: NextFunction) {
    const usertoken = req.headers.authorization;
    const decoded = jwt.decode(usertoken, "shadow");
    console.log(decoded);
    const user = await Users.aggregate([
      { $match: { _id: mongoose.Types.ObjectId(decoded.id) } },
      {
        $lookup: {
          from: "posts",
          localField: "_id",
          foreignField: "userId",
          as: "posts",
        },
      },
      {
        $project: {
          _id: 0,
          password: 0,
        },
      },
    ]).exec();
    res.json(user);
  }
}

export default ProfileController;
