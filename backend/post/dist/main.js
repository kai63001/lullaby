"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var app_1 = __importDefault(require("./app"));
var post_controller_1 = __importDefault(require("./controller/post/post.controller"));
var profile_controller_1 = __importDefault(require("./controller/profile/profile.controller"));
var app = new app_1.default([new post_controller_1.default(), new profile_controller_1.default()]);
app.listen();
