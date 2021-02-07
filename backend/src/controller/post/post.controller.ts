import express, {Application, Request, Response, NextFunction} from 'express';
import authRequest from '../../interfaces/auth.ext';
const Posts = require('../../models/posts.model')
const jwt = require("jwt-simple");

class UsersController {

  public router: express.Router = express.Router();
  public path: string = '/';

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
    this.router.get('/post',authRequest, this.getAllPost);
    this.router.post('/post',authRequest, this.insertPost);
  }

  private getAllPost( req: Request, res: Response, next: NextFunction):void {
    Posts.find({}, (err:any,result:any)=>{
        if(err){
            console.log(err)
            res.send(err)
        }else{
            res.send(result)
        }
    })
  }

  private insertPost( req: Request, res: Response, next: NextFunction):void {
    const usertoken = req.headers.authorization
    const decoded = jwt.decode(usertoken, "shadow")
    Posts.insertMany([
      {
        title:req.body.title,
        userId:decoded.userId,
        date: Date.now()
      }
    ], (_err: any)=> {
          if(_err) {
              console.log(_err)
          }else{
              res.send("added")
          }
      })
  }

}

export default UsersController;