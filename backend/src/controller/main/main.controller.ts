import express, {Application, Request, Response, NextFunction} from 'express';

class UsersController {

  public router: express.Router = express.Router();
  public path: string = '/as';

  constructor() {
    this.initializeRoutes();
  }

  public initializeRoutes() {
    this.router.get('/', this.getAllUsers);
  }

  async getAllUsers(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
    res.send("test")
  }

}

export default UsersController;