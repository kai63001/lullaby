import App from "./app";

import PostController from "./controller/post/post.controller";

const app = new App([new PostController()]);

app.listen();