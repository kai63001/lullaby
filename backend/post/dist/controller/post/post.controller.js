"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = __importDefault(require("express"));
var auth_ext_1 = __importDefault(require("../../interfaces/auth.ext"));
var Posts = require("../../models/posts.model");
var Likes = require("../../models/likes.model");
var Comments = require("../../models/comments.model");
var jwt = require("jwt-simple");
var mongoose = require("mongoose");
var PostsController = /** @class */ (function () {
    function PostsController() {
        this.router = express_1.default.Router();
        this.path = "/";
        this.initializeRoutes();
    }
    PostsController.prototype.initializeRoutes = function () {
        this.router.get("/post", auth_ext_1.default, this.getAllPost);
        this.router.post("/post", auth_ext_1.default, this.insertPost);
        this.router.get("/post/like/:id", auth_ext_1.default, this.likeFrist);
        this.router.delete("/post/:id", auth_ext_1.default, this.deletePost);
        this.router.get("/post/like/:id/update", auth_ext_1.default, this.updateLikePost);
        this.router.get("/post/unlike/:id", auth_ext_1.default, this.disLike);
        this.router.get("/post/:id/comment", auth_ext_1.default, this.commentList);
        this.router.post("/post/:id/comment", auth_ext_1.default, this.comment);
        this.router.post("/post/:id/comment/add", auth_ext_1.default, this.commentAdd);
        this.router.delete("/post/:id/comment/delete", auth_ext_1.default, this.commentDelete);
    };
    PostsController.prototype.getAllPost = function (req, res, next) {
        return __awaiter(this, void 0, void 0, function () {
            var perPage, page, apr;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        perPage = parseInt(req.query.limit) || 8;
                        page = req.query.page || Date.now().toString();
                        return [4 /*yield*/, Posts.aggregate([
                                { $match: { date: { $lte: parseInt(page) - 1 } } },
                                { $sort: { date: -1 } },
                                {
                                    $lookup: {
                                        from: "users",
                                        localField: "userId",
                                        foreignField: "_id",
                                        as: "users",
                                    },
                                },
                                {
                                    $lookup: {
                                        from: "likes",
                                        localField: "_id",
                                        foreignField: "postId",
                                        as: "likes",
                                    },
                                },
                                {
                                    $lookup: {
                                        from: "comments",
                                        localField: "_id",
                                        foreignField: "postId",
                                        as: "comments",
                                    },
                                },
                                {
                                    $project: {
                                        "users._id": 0,
                                        "users.password": 0,
                                        "likes._id": 0,
                                        "likes.postId": 0,
                                        "comments.postId": 0,
                                        "comments._id": 0,
                                    },
                                },
                                {
                                    $addFields: {
                                        haveLike: { $size: "$likes" },
                                        haveComment: { $size: "$comments" },
                                    },
                                },
                                {
                                    $facet: {
                                        data: [{ $limit: perPage }],
                                    },
                                },
                            ]).exec()];
                    case 1:
                        apr = _a.sent();
                        res.json(apr);
                        return [2 /*return*/];
                }
            });
        });
    };
    PostsController.prototype.insertPost = function (req, res, next) {
        var usertoken = req.headers.authorization;
        var decoded = jwt.decode(usertoken, "shadow");
        Posts.insertMany([
            {
                title: req.body.title,
                userId: mongoose.Types.ObjectId(decoded.id),
                feel: req.body.feel,
                feelColor: req.body.feelColor,
                date: Date.now(),
            },
        ], function (_err) {
            if (_err) {
                console.log(_err);
            }
            else {
                res.send("post success");
            }
        });
    };
    PostsController.prototype.likeFrist = function (req, res, next) {
        var usertoken = req.headers.authorization;
        var decoded = jwt.decode(usertoken, "shadow");
        Likes.insertMany([
            {
                postId: mongoose.Types.ObjectId(req.params.id),
                users: [mongoose.Types.ObjectId(decoded.id)],
            },
        ], function (_err) {
            if (_err) {
                console.log(_err);
            }
            else {
                res.send("Like success");
            }
        });
    };
    PostsController.prototype.updateLikePost = function (req, res) {
        var usertoken = req.headers.authorization;
        var decoded = jwt.decode(usertoken, "shadow");
        Likes.updateOne({ postId: mongoose.Types.ObjectId(req.params.id) }, { $push: { users: [mongoose.Types.ObjectId(decoded.id)] } }, function (error, success) {
            if (error) {
                res.send(error);
            }
            else {
                res.send("update like success");
            }
        });
    };
    PostsController.prototype.disLike = function (req, res) {
        var usertoken = req.headers.authorization;
        var decoded = jwt.decode(usertoken, "shadow");
        Likes.updateOne({ postId: mongoose.Types.ObjectId(req.params.id) }, { $pullAll: { users: [mongoose.Types.ObjectId(decoded.id)] } }, function (error, success) {
            if (error) {
                res.send(error);
            }
            else {
                res.send("unlike success");
            }
        });
    };
    PostsController.prototype.comment = function (req, res) {
        var usertoken = req.headers.authorization;
        var decoded = jwt.decode(usertoken, "shadow");
        Comments.insertMany([
            {
                postId: mongoose.Types.ObjectId(req.params.id),
                userId: mongoose.Types.ObjectId(decoded.id),
                comment: req.body.comment,
                date: Date.now()
                // comments: [
                //   {
                //     userId: mongoose.Types.ObjectId(decoded.id),
                //     comment: req.body.comment,
                //     date: Date.now()
                //   },
                // ],
            },
        ], function (_err) {
            if (_err) {
                console.log(_err);
            }
            else {
                res.send("comment success");
            }
        });
    };
    PostsController.prototype.commentAdd = function (req, res) {
        // const usertoken = req.headers.authorization;
        // const decoded = jwt.decode(usertoken, "shadow");
        // Comments.updateOne(
        //   { postId: mongoose.Types.ObjectId(req.params.id) },
        //   {
        //     $push: {
        //       comments: [
        //         {
        //           userId: mongoose.Types.ObjectId(decoded.id),
        //           comment: req.body.comment,
        //           date: Date.now()
        //         },
        //       ],
        //     },
        //   },
        //   function (error: any, success: any) {
        //     if (error) {
        //       res.send(error);
        //     } else {
        //       res.send("comment add success");
        //     }
        //   }
        // );
    };
    PostsController.prototype.commentDelete = function (req, res) {
        var usertoken = req.headers.authorization;
        var decoded = jwt.decode(usertoken, "shadow");
        Comments.deleteOne({ _id: mongoose.Types.ObjectId(req.params.id), userId: mongoose.Types.ObjectId(decoded.id) }, function (err) {
            if (err) {
                res.send("err");
            }
            else {
                res.send("delete success");
            }
        });
    };
    PostsController.prototype.commentList = function (req, res) {
        return __awaiter(this, void 0, void 0, function () {
            var apr;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, Comments.aggregate([
                            { $match: { postId: { $eq: mongoose.Types.ObjectId(req.params.id) } } },
                            { $sort: { date: -1 } },
                            {
                                $lookup: {
                                    from: "users",
                                    localField: "userId",
                                    foreignField: "_id",
                                    as: "users",
                                },
                            },
                            {
                                $project: {
                                    "users._id": 0,
                                    "users.password": 0,
                                },
                            },
                        ]).exec()];
                    case 1:
                        apr = _a.sent();
                        res.json(apr);
                        return [2 /*return*/];
                }
            });
        });
    };
    PostsController.prototype.deletePost = function (req, res) {
        return __awaiter(this, void 0, void 0, function () {
            var usertoken, decoded;
            return __generator(this, function (_a) {
                usertoken = req.headers.authorization;
                decoded = jwt.decode(usertoken, "shadow");
                Posts.deleteOne({ _id: mongoose.Types.ObjectId(req.params.id), userId: mongoose.Types.ObjectId(decoded.id) }, function (err) {
                    if (err) {
                        res.send("err");
                    }
                    else {
                        res.send("delete posts success");
                    }
                });
                return [2 /*return*/];
            });
        });
    };
    return PostsController;
}());
exports.default = PostsController;
