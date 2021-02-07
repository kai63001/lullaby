import express, {Application, Request, Response, NextFunction} from 'express';
import loginMiddleWare from '../../middleware/auth/login.middleware';
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
    this.router.post(`${this.path}/register`, authRequest, this.register);

  }

  private async login(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
      const payload = {
          sub: req.body.username,
          iat: new Date().getTime()
      };
      res.send(jwt.encode(payload, "shadow"));
  }

  private async register(req:Request,res:Response){

  }

  private async logout(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
      // const usertoken = req.headers.authorization
      // const decode = jwt.decode(usertoken,"shadow")
      // const payload = {
      //     sub: decode.sub,
      //     iat: 0
      // }
      // res.send(jwt.encode(payload,"shadow"))
      res.send("logout")
  }

}

export default Auth;