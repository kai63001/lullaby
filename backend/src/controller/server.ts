const bodyParser = require("body-parser");
import express, {Application, Request, Response, NextFunction} from 'express';
// import Users from '../models/users.model';
const Users = require("../models/users.model");

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
            Users.findOne({username:"ssa"}, function(err: any, result: any) {
                if (err) {
                    res.send(err);
                } else if(!result){
                    res.json({
                        "status":"not found"
                    })
                } else {
                    res.send(result);
                }
            });
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