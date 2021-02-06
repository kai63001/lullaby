const bodyParser = require("body-parser");
import express, {Application, Request, Response, NextFunction} from 'express';

class Server {
    
    private app:Application;
    private port:number;

    constructor(port:number){
        this.app = express();
        this.port = port;
        this.config();
        this.run();
    }

    private config():void {
        this.app.get("/",(req:Request, res:Response, next:NextFunction) => {
            res.send("fucmj u");
        })
    }

    private run():void {
        this.app.use(bodyParser.json());
        this.app.listen(this.port, ()=> {
            console.log(`server start on port : ${this.port}`)
        })
    }

}

export default Server;