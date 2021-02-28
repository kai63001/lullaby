import Controller from "./interfaces/controller.interface";
const bodyParser = require("body-parser");
import express, {Application, Request, Response, NextFunction} from 'express';
import Db from './connection/db'
const cors = require('cors')
class App {
  public app: Application;

  constructor(controllers: Controller[]) {
    this.app = express();

    this.connectToTheDatabase();
    this.initializeMiddlewares();
    this.initializeControllers(controllers);
  }

  public listen() {
    this.app.listen(process.env.PORT || 3000, () => {
      console.log(`App listening on the port (PROFILE SYSTEM) ${process.env.PORT || 3000}`);
    });
  }

  private initializeMiddlewares() {
    this.app.use(bodyParser.json());
  }

   private initializeControllers(controllers: Controller[]) {
    controllers.forEach(controller => {
      this.app.use("/", controller.router);
    });
  }

  private connectToTheDatabase() {
    this.app.use(cors())
    const Connect = new Db();
  }
}

export default App;