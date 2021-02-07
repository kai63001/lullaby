import App from "./app";

import UsersController from "./controller/main/main.controller";
import AuthController from "./controller/auth/auth.controller";

const app = new App([new UsersController(),new AuthController()]);

app.listen();