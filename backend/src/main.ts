import App from "./app";

import PostController from "./controller/post/post.controller";
import AuthController from "./controller/auth/auth.controller";

const app = new App([new PostController(),new AuthController()]);

app.listen();