const firebase = require("firebase-admin");
const serviceAccount = require("./firebase-admin.json");

const admin = firebase.initializeApp({
  credential: firebase.credential.cert(serviceAccount),
  storageBucket: "ios-instagram-73246.appspot.com",
});

module.exports = admin;
