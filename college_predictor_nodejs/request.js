const express = require("express");
const userIP = require("./save");


const app = express()

// Middleware to parse JSON and URL-encoded bodies
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.post("/UserPass", async (req, res) => {
    const { gmail, pass } = req.body;

    console.log("User and password", req.body);
    console.log("Gmail: ", gmail, "Password: ", pass);
    res.redirect("http://localhost:8081/Collegepredictor/college_project/main-page/main.jsp");
});


app.post("/predict", async (req, res) => {
    const { Phy, Math, Che, Com ,User , Pass } = req.body; 

    // Log the incoming values for debugging
    console.log('Received data:', req.body);

    // Check if all required fields are present
    if (Phy === undefined || Math === undefined || Che === undefined || Com === undefined) {
        console.log("Missing required fields");
        return res.status(400).json({ error: 'Missing required fields' });
    }

    // Perform your prediction logic here
    const predictionValue = (parseFloat(Phy) + parseFloat(Math) + parseFloat(Che)) / 3;

    const userip = new userIP({
        Phy,
        Math,
        Che,
        Com,
        currDate: new Date(),
        Pred: predictionValue
    });

    try {
        await userip.save();
        const re = JSON.stringify({ pred: predictionValue })
        res.redirect("http://localhost:8081/Collegepredictor/college_project/main-page/main.jsp?&sum="+re)
    } catch (err) {
        console.error('Error saving prediction to database', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
