"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var app_1 = __importDefault(require("./app"));
var auth_controller_1 = __importDefault(require("./controller/auth/auth.controller"));
var app = new app_1.default([new auth_controller_1.default()]);
app.listen();
