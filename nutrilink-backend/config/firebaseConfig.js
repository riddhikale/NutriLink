// // Import the functions you need from the SDKs you need
// import { initializeApp } from "firebase/app";
// import { getAnalytics } from "firebase/analytics";
// // TODO: Add SDKs for Firebase products that you want to use
// // https://firebase.google.com/docs/web/setup#available-libraries

// const apiKey = process.env.FIREBASE_APIKEY;
// const authdomain = process.env.AUTH_DOMAIN;
// const projectid = process.env.PROJECT_ID;
// const storagebucket = process.env.STORAGE_BUCKET;
// const messagingsenderid = process.env.MESSAGING_SENDER_ID;
// const appid = process.env.APP_ID;
// const measurementid = process.env.MEASUREMENT_ID;

// // Your web app's Firebase configuration
// // For Firebase JS SDK v7.20.0 and later, measurementId is optional
// const firebaseConfig = {
//   apiKey: apiKey,
//   authDomain: authdomain,
//   projectId: projectid,
//   storageBucket: storagebucket,
//   messagingSenderId: messagingsenderid,
//   appId: appid,
//   measurementId: measurementid 
// };

// // Initialize Firebase
// const app = initializeApp(firebaseConfig);
// const analytics = getAnalytics(app);

const admin = require("firebase-admin");
const serviceAccount = require("../serviceAccount.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

module.exports = {admin, db};