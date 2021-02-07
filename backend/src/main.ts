import App from "./app";

import UsersController from "./controller/main/main.controller";

const app = new App([new UsersController()]);

app.listen();