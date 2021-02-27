import App from "./app";

import AuthController from "./controller/auth/auth.controller";

const app = new App([new AuthController()]);

app.listen();