var express = require("express")
var mongoose = require("mongoose")


const app = express()

const url = 'mongodb://localhost:27017/collegePredictor';

// Creating a connection
mongoose.connect(url , {useNewUrlParser : true , useUnifiedTopology : true} ).then(() => {

  console.log("Connected successfully") 
}).catch((err) => {
  console.log("Error occured" , err);
})

// Defining the schema
const userSchema = mongoose.Schema({

  User : String ,
  Pass : String ,
  data :  [
            {
              Phy : Number,
              Che : Number ,
              Math : Number ,
              Com : String,
              currDate : Date,
              curoff : Number 
            }
  ]
})


// Creating a model(collection)

const userInput = mongoose.model("UserInputs",userSchema);

module.exports = userInput;