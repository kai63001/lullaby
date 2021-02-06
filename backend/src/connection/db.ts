const mongoose = require("mongoose");

class db {

    constructor(){
        this.connect()
    }

    private connect():void {
        console.log("connecting")
        var uri = "mongodb+srv://lullaby:Lay@22331@cluster0.80apm.mongodb.net/lullaby?retryWrites=true&w=majority";

        mongoose.connect(uri, { useUnifiedTopology: true, useNewUrlParser: true });

        const connection = mongoose.connection;

        connection.once("open", function() {
            console.log("MongoDB database connection established successfully");
        });
    }
}

export default db;