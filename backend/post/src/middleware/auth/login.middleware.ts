import { NextFunction,Response, Request } from 'express';
const Users = require("../../models/users.model");

function loginMiddleWare(req: any, res: Response, next: NextFunction) {
    Users.findOne({username:req.body.username,password:req.body.password}, function(err: any, result: any) {
        if (err) {
            res.send(err);
        } else if(!result){
            res.send("not found")
        } else {
            req.userId = result._id;
            next();
        }
    });
}

export default loginMiddleWare;