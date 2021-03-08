const mongoose = require("mongoose");

class db {

    constructor(){
        this.connect()
    }

    private connect():void {
        console.log("connecting")
        var uri = "mongodb://mongo:27017/lullaby";

        mongoose.connect(uri, { useUnifiedTopology: true, useNewUrlParser: true ,useFindAndModify: false,useCreateIndex:true});

        const connection = mongoose.connection;

        connection.once("open", function() {
            console.log("MongoDB database connection established successfully");
        });
    }
}

export default db;