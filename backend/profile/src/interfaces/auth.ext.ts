const passport = require("passport");
const ExtractJwt = require("passport-jwt").ExtractJwt;
const JwtStrategy = require("passport-jwt").Strategy;
const SECRET = "shadow";
const jwtOptions = {
   jwtFromRequest: ExtractJwt.fromHeader("authorization"),
   secretOrKey: SECRET
};
const jwtAuth = new JwtStrategy(jwtOptions, (payload:any, done:any) => {
   if (payload.username) done(null, true);
   else done(null, false);
});
passport.use(jwtAuth);
const requireJWTAuth = passport.authenticate("jwt",{session:false});

export default requireJWTAuth;