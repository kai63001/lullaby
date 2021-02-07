import express, {Application, Request, Response, NextFunction} from 'express';
import authRequest from '../../interfaces/auth.ext';

class UsersController {

  public router: express.Router = express.Router();
  public path: string = '/';

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
    this.router.get('/',authRequest, this.getAllUsers);
  }

  private async getAllUsers(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
    res.send("test")
  }

}

export default UsersController;