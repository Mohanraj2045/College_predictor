const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.send('Welcome to the Express server');
});

app.post('/recommendation', async (req, res) => {
  const { Cutoff, Com, BranchCode } = req.body;

  console.log(Cutoff, Com, BranchCode)

  try {
    const response = await axios.post('http://127.0.0.1:4000/recommend', {
      Cutoff: Cutoff,
      Com: Com,
      BranchCode: BranchCode,
    });

    res.json(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).send('An error occurred while making the request');
  }
});

app.listen(port, () => {
  console.log(`Express server is running on http://localhost:${port}`);
});
