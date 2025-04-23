// web/firebase-config.js

// Import Firebase
import firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';
import 'firebase/storage';

// Firebase configuration object
const firebaseConfig = {
  apiKey: "AIzaSyBMIYukgPYU7fbMNu-qhmmyuIGGE6b2fQM",
  authDomain: "recipe-and-meal-planner-f276b.firebaseapp.com",
  projectId: "recipe-and-meal-planner-f276b",
  storageBucket: "recipe-and-meal-planner-f276b.firebasestorage.app",
  messagingSenderId: "330978033723",
  appId: "1:330978033723:web:b24742f8e0c75e2fd9dc1e",
  measurementId: "G-ZWP4345L3T"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Firebase services (optional, depending on what you use)
const auth = firebase.auth();
const firestore = firebase.firestore();
const storage = firebase.storage();

export { auth, firestore, storage }; // Export services for use in your app
