var express = require("express");
var router = express.Router();
const firebase = require("../admin");
const multer = require("multer");

const upload = multer({ storage: multer.memoryStorage() });

const bucket = firebase.storage().bucket();
const db = firebase.firestore();

/* GET users listing. */
router.get("/", async function (req, res, next) {
  res.send("respond with a resource");
});

router.post("/upload", upload.single("file"), async (req, res) => {
  if (!req.file) {
    return res.status(400).send("No file uploaded.");
  }

  try {
    const blob = bucket.file(`post_image/${req.file.originalname}`);
    const blobStream = blob.createWriteStream({
      metadata: {
        contentType: req.file.metadata,
      },
    });

    blobStream.on("error", (err) => {
      return res.status(500).send(err.message);
    });

    blobStream.on("finish", () => {
      const publicUrl = `https://firebasestorage.googleapis.com/v0/b/${
        bucket.name
      }/o/${encodeURIComponent(blob.name)}?alt=media`;
      return res.status(200).send({ url: publicUrl });
    });

    blobStream.end(req.file.buffer);
  } catch (error) {
    return res.status(500).send(error.message);
  }
});

router.post("/register", async (req, res) => {
  try {
    const { email, password, fullName, userName, profileImageUrl } = req.body;
    const userRecord = await firebase.auth().createUser({ email, password });

    const userRef = db.collection("users").doc(userRecord.uid);
    await userRef.set({
      email,
      fullName,
      profileImageUrl,
      userName,
      uid: userRecord.uid,
    });

    res.status(201).send();
  } catch (error) {
    console.log(error.message);
    res.status(500).send(error.message);
  }
});

module.exports = router;
