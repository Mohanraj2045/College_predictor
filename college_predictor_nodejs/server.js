    const express = require("express");
    const http = require("http");
    const session = require("express-session");

    const app = express();
    const port = 3000;

    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));


    //  Secret is secter key to access the session
    //  resave forces the session to be saved even if is it modified
    //  saveUninitialized force the uninilized session to be saved
    app.use(session({ secret:"This is my secret key" ,
                     saveUninitialized : true ,
                    resave:true,
                    maxAge: 60 * 60 * 1000 // Set to 1 hour for testing

                    }))

    app.post('/predict', function (req, res) {
        const { Phy, Math, Che, Com } = req.body;
        

        const sum = Number(Phy) + Number(Math) + Number(Che);

        console.log("Sum stored in session:", sum ,req.session.sum );

        res.redirect("http://localhost:8081/Collegepredictor/college_project/main-page/main.jsp?sum=" + sum);

    });

    app.listen(port, function (err) {
        if (err) {
            console.log("Error occurred", err);
        } else {
            console.log("Successfully running on port", port);
        }
    });
