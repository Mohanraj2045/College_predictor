const express = require("express");
const mongoose = require("mongoose");
const userInput = require("./schemaCollection");
const axios = require("axios");

const app = express();

// Middleware to parse JSON and URL-encoded bodies
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.post("/Predictsave", async (req, res) => {
    try {
        const { Phy, Math, Che, Com, User, Pass, BranchCode } = req.body;
        console.log("Received data:", { Phy, Math, Che, Com, User, Pass, BranchCode });

        const cutoff = ((Number(Phy) + Number(Che)) / 2) + (Number(Math));

        // Find user by User and Pass
        let user = await userInput.findOne({ User, Pass });

        if (user) {
            console.log("User exists");
            user.data.push({ Phy, Che, Math, Com, cutoff, currDate: new Date() });
            await user.save();
        } else {
            console.log("User does not exist");
            user = new userInput({
                User,
                Pass,
                data: [{ Phy, Che, Math, Com, cutoff, currDate: new Date() }]
            });
            await user.save();
        }

        console.log(cutoff);
        // Sending data to Python API
        const response = await axios.post('http://localhost:4000/recommend', {
            Cutoff: Number(cutoff),
            Com: Com,
            BranchCode: BranchCode,
        });

        console.log("Data from Python API:", response.data);
        const collegeData = response.data.Colleges;

        // Redirect to JSP hosted on Tomcat with collegeData as query parameters
       const encodedColleges = encodeURIComponent(JSON.stringify(collegeData)); // if send get(query in ulr) encode it so it will handle spl characters  


       res.redirect(`http://localhost:8081/Collegepredictor/college_project/main-page/main.jsp?colleges=${encodedColleges}`);

    } catch (error) {
        console.error("Error occurred:", error);
        res.status(500).send("Internal Server Error");

    }
    
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
