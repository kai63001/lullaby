import { NextFunction,Response, Request } from 'express';
const Users = require("../../models/users.model");

function registerMiddleWare(req: Request, res: Response, next: NextFunction) {
    if(req.body.password != req.body.conpassword){
        res.send("password not match")
    }else{
        Users.findOne({username:req.body.username}, function(err: any, result: any) {
            if (err) {
                res.send(err);
            } else if(result){
                res.send("username already exit")
            } else {
                Users.insertMany([{username:req.body.username,password:req.body.password}], (_err: any)=> {
                    if(_err) {
                        console.log(_err)
                    }else{
                        next();
                    }
                })
            }
        });
    }
}

export default registerMiddleWare;