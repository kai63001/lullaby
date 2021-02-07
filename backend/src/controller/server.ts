const bodyParser = require("body-parser");
import express, {Application, Request, Response, NextFunction} from 'express';
const Users = require("../models/users.model");
const jwt = require("jwt-simple");
const passport = require("passport");
const ExtractJwt = require("passport-jwt").ExtractJwt;
const JwtStrategy = require("passport-jwt").Strategy;
const SECRET = "shadow";
const jwtOptions = {
   jwtFromRequest: ExtractJwt.fromHeader("authorization"),
   secretOrKey: SECRET
};
const jwtAuth = new JwtStrategy(jwtOptions, (payload:any, done:any) => {
   if (payload.sub) done(null, true);
   else done(null, false);
});
passport.use(jwtAuth);
const requireJWTAuth = passport.authenticate("jwt",{session:false});

class Server {
    
    private app:Application;
    private port:number;
    // private auth:Auther = new Auther();

    constructor(port:number){
        this.app = express();
        this.port = port;
        this.app.use(bodyParser.json());
        this.config();
        this.run();
    }

    private config():void {
        
        const loginMiddleWare = (req:Request, res:Response, next:NextFunction) => {
            Users.findOne({username:req.body.username,password:req.body.password}, function(err: any, result: any) {
                if (err) {
                    res.send(err);
                } else if(!result){
                    res.json({
                        "status":"not found"
                    })
                } else {
                    next();
                }
            });
        };

        this.app.post("/login", loginMiddleWare, (req:Request, res:Response) => {
            const payload = {
                sub: req.body.username,
                iat: new Date().getTime()
            };
            res.send(jwt.encode(payload, SECRET));
        });

        this.app.post("/register", (req:Request,res:Response) => {
            
        });

        this.app.get("/",requireJWTAuth,(req:Request, res:Response, next:NextFunction) => {
            res.send("ยอดเงินคงเหลือ 50");;
        })

        this.app.get('/logout', requireJWTAuth, (req:Request, res:Response, next:NextFunction) => {
            const usertoken = req.headers.authorization
            jwt.destroy(usertoken)
            res.send('logout')
        })

    }

    private run():void {
        this.app.listen(this.port, ()=> {
            console.log(`server start on port : ${this.port}`)
        })
    }

}

export default Server;