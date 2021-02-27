"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function loggerMiddleware(request, response, next) {
    response.send(request.body);
}
exports.default = loggerMiddleware;
