import App from "./app";

import PostController from "./controller/post/post.controller";
import AuthController from "./controller/auth/auth.controller";
import ProfileController from "./controller/profile/profile.controller";

const app = new App([new PostController(),new AuthController(),new ProfileController()]);

app.listen();