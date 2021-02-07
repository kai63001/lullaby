import express, {Application, Request, Response, NextFunction} from 'express';
import loginMiddleWare from '../../middleware/auth/login.middleware';
import registerMiddleWare from '../../middleware/auth/register.middleware';
const jwt = require("jwt-simple");
import authRequest from '../../interfaces/auth.ext';

class Auth {

  public router: express.Router = express.Router();
  public path: string = '/auth';

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
    this.router.post(`${this.path}/login`, loginMiddleWare, this.login);
    this.router.get(`${this.path}/logout`, authRequest, this.logout);
    this.router.post(`${this.path}/register`, registerMiddleWare, this.register);

  }

  private async login( req: any, res: Response, next: NextFunction) {
      const payload = {
          id: req.userId,
          username: req.body.username,
          iat: new Date().getTime()
      };
      res.send(jwt.encode(payload, "shadow"));
  }

  private async register(req:Request,res:Response){
    res.send("register success")
  }

  private async logout( req: Request, res: Response, next: NextFunction) {
      res.send("logout")
  }

}

export default Auth;