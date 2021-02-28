import App from "./app";

import ProfileController from "./controller/profile/profile.controller";

const app = new App([new ProfileController()]);

app.listen();