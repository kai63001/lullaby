import express, { Application, Request, Response } from 'express'
// import Index from './views/Index'

export default class Server {
    private app: Application;
    private port:number;
    constructor(port:number) {
        this.port = port;
        this.app = express();
        this.run()
        this.config()
    }

    private config():void {
        this.app.get('/',(req:Request,res:Response) => {
            res.send("welcome")
        });
    }

    private run():void {
        this.app.listen(this.port, () => {
            console.log("server run port" + this.port)
        })
    }

    public status():void {
        console.log("runing")
    }
}