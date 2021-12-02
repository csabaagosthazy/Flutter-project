const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

let startTime = new Date();

function randomNumber(min, max) {
  return Math.round(Math.random() * (max - min) + min);
}

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get("/", (req, res) => {
  const date = new Date();
  const diff = Math.round((date - startTime) / 1000);
  if (diff > 2000) startTime = new Date();
  const freq = randomNumber(40, 50);
  const temp = randomNumber(25, 32);
  const hum = randomNumber(20, 35);
  const time = diff + ":01:01";
  const responseString = `${time} ${freq} ${temp} ${hum}`;
  res.send(responseString);
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
