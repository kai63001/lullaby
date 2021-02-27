import App from "./app";

import PostController from "./controller/post/post.controller";
import ProfileController from "./controller/profile/profile.controller";

const app = new App([new PostController(),new ProfileController()]);

app.listen();