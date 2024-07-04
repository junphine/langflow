// Import the functions you need from the SDKs you need

import { initializeApp } from "firebase/app";
import { MockUntyped as Mock } from "firebase/mock-untyped";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getDatabase } from "firebase/database";
import { getStorage } from "firebase/storage";

import data from "./data.json";

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseDevConfig = {
  authURL: "http://127.0.0.1:3000/", 
  apiKey: "AIzaSyBfirsbIgWxorN8HZ5jE8Vhqv8HGXyL7fY",
  authDomain: "sequill-3d3be.firebaseapp.com",
  projectId: "sequill-3d3be",  
  messagingSenderId: "966415000495",
  appId: "1:966415000495:web:53cf6c3e97fa86f205c55a",
  measurementId: "G-NGWJESH9FY",
  databaseURL: "https://nightlight.firebaseio.com",
  storageBucket: "data",  
};

const firebaseConfig = {
  authURL: "http://172.16.29.84:3000/",
  apiKey: "AIzaSyBfirsbIgWxorN8HZ5jE8Vhqv8HGXyL7fY",
  authDomain: "sequill-3d3be.firebaseapp.com",
  projectId: "sequill-3d3be",  
  messagingSenderId: "966415000495",
  appId: "1:966415000495:web:53cf6c3e97fa86f205c55a",
  measurementId: "G-NGWJESH9FY",
  databaseURL: "https://nightlight.firebaseio.com",
  storageBucket: "data",  
};

const fieldPath = { documentId: {} };
const fieldValue = { delete: {} };

const store = { content: data };

const database = {
  content: {
      
  }
};

const mockDev = new Mock({
  
  identities: [{email:"admin@test.com",password:"123456",'photoURL':'http://127.0.0.1:18080/filemanager/file/igfs/images/avatar.jpg'}],   
  firestore: {
    endpoint: 'http://127.0.0.1:18080/filemanager/docs/',        
    fieldPath,
    fieldValue,
    ...store
  },
  database: database,
  storage: {
    endpoint: 'http://127.0.0.1:18080/filemanager/s3/',
    region: 'default',
    credentials: {}
  }
});

const mock = new Mock({  
  identities: [{email:"admin@test.com",password:"123456",'photoURL':'http://172.16.29.84:3080/filemanager/file/igfs/images/avatar.jpg'}],  
  firestore: {
    endpoint: 'http://172.16.29.84:3080/filemanager/docs/',    
    fieldPath,
    fieldValue,
    ...store
  },
  database: database,
  storage: {
    endpoint: 'http://172.16.29.84:3080/filemanager/s3/',
    region: 'default',
    credentials: {}
 }
});

// Initialize Firebase
// export const appDev = mock_local.initializeApp(firebaseDevConfig);
export const app = mock.initializeApp(firebaseConfig);
export const auth = app.auth();
export const db = app.firestore();
export const kvdb = app.database();
export const storage = app.storage();

auth.onAuthStateChanged(
  (user) => { 
    console.log(user); 
  },
  (error) => { 
    console.error(error); 
  }
)

//auth.createUserWithEmailAndPassword("junphine@126.com","332584185")
//auth.createUserWithEmailAndPassword("admin@goole.com","123456")
//auth.signInWithEmailAndPassword("admin@test.com","123456")

//auth.signInWithEmailAndPassword("junphine@126.com","332584185")
/** 
.then(user=>{
    
  let res = auth.createUser({
    displayName: "demo2",
    email: "demo@srv.mail.cn",
    emailVerified: true,
    phoneNumber: "13772450552",
    photoURL: '',
    disabled: false,
    password: '123456',
  })

  res.then(r=>{
    console.log(r);
    if(r.uid){
      auth.updateUser(r.uid,{displayName: "demo3"})
    }    
  })

  res = auth.listUsers().then(r=>{
    console.log(r);
  }) 
})
*/

export const usersRef = db.collection("users");