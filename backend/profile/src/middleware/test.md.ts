import { NextFunction,Response, Request } from 'express';

function loggerMiddleware(request: Request, response: Response, next: NextFunction) {
  response.send(request.body)
}

export default loggerMiddleware;