/**
 * @license Use of this source code is governed by a GPL-3.0 license that
 * can be found in the LICENSE file at https://github.com/cartant/firebase-nightlight
 */

import { EventEmitter2, Listener } from "eventemitter2";
import { firebase } from "../firebase";
import { error_, unsupported_ } from "../mock-error";
import { MockIdentity } from "./mock-auth-types";
import { MockUser } from "./mock-user";

export interface MockAuthOptions {
    app: firebase.app.App;
    identities: MockIdentity[];
    authURL: string;
}

export class MockAuth implements firebase.auth.Auth {

    private app_: firebase.app.App;
    private currentUser_: firebase.User | null;
    private emitter_: EventEmitter2;
    private identities_: MockIdentity[];
    private options_: MockAuthOptions;
    private accessToken_?: string | null;

    constructor(options: MockAuthOptions) {

        this.app_ = options.app;
        this.options_ = options;
        this.currentUser_ = null;
        this.emitter_ = new EventEmitter2();
        this.identities_ = options.identities;        
        
    }

    get app(): firebase.app.App {

        return this.app_;
    }

    get currentUser(): firebase.User | null {

        return this.currentUser_;
    }

    get languageCode(): string | null {

        throw unsupported_();
    }

    get apiHeader(): HeadersInit {
        if (this.accessToken_){
            return {'Content-Type': 'application/json', 'Authorization': 'Token '+this.accessToken_};
        }            
        else {
            return {'Content-Type': 'application/json'};
        }        
    }

    applyActionCode(code: string): Promise<any> {

        throw unsupported_();
    }

    checkActionCode(code: string): Promise<any> {

        throw unsupported_();
    }

    confirmPasswordReset(code: string, password: string): Promise<any> {

        throw unsupported_();
    }

    createCustomToken(uid: string, developerClaims?: Object): Promise<string> {

        throw unsupported_();
    }

    createUser(properties: firebase.auth.CreateRequest): Promise<firebase.auth.UserRecord> {
        const authURL = this.options_['authURL'];
        const parts = properties.email.split('@');
        let userInfo = {
            email: properties.email, 
            password: properties.password, 
            displayName: properties.displayName || parts[0],
            firstName: properties.firstName || parts[0],
            lastName: properties.lastName || ' ',  
            phone: properties.phoneNumber,
            photoURL: properties.photoURL,
            company: properties.company || parts[1],
            country: "China",      
        }
        return fetch(authURL+'api/v1/signup',{
            method: 'POST', mode: "cors", credentials: "include",
            headers: this.apiHeader,
            body: JSON.stringify(userInfo)
        })
        .then(response => response.json())        
        .then(json=>{
            if (json['message']){
                this.emitter_.emit("error", json);
                const currentUser = new MockUser(userInfo);
                return currentUser;
            }
            else{
                const user = json;
                this.identities_.push(user);
                const currentUser = new MockUser(user);
                this.emitter_.emit("auth", currentUser);
                return currentUser;
            }
            
        });
    }

    createUserWithEmailAndPassword(email: string, password: string): Promise<any> {

        const identity = this.identities_.find((identity) => identity.email === email);
        if (identity) {
            return Promise.reject(error_("auth/email-already-in-use", "Email already in use."));
        }        
        const parts = email.split('@');
        let userInfo = {
            email: email, 
            password: password, 
            displayName: parts[0],
            firstName: parts[0], 
            lastName: ' ',  
            phone: '',
            company: parts[1], 
            country: "China",
        }

        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/signup',{
            method: 'POST', mode: "cors", credentials: "include",
            headers: this.apiHeader,
            body: JSON.stringify(userInfo),
        })
        .then(response => response.json())        
        .then(json=>{
            if (json['message']){
                this.emitter_.emit("error", json);
                const currentUser = new MockUser(userInfo);
                return currentUser;
            }
            else{
                const user = json;
                this.identities_.push(user);
                const currentUser_ = new MockUser(user);
                this.emitter_.emit("auth", currentUser_);
                return currentUser_;
            }
            
        })
        
    }

    deleteUser(uid: string): Promise<void> {
        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/admin/users/'+uid,{
            method:'DELETE',mode: "cors",credentials:"include",
            headers: this.apiHeader,
        })
        .then(response => response.json())
        .then(json =>{
            if (json['message']){
                this.emitter_.emit("error", json);
            }       
        })
    }

    fetchProvidersForEmail(email: string): Promise<any> {

        throw unsupported_();
    }

    getRedirectResult(): Promise<any> {

        return Promise.resolve({
            credential: null,
            user: null
        });
    }

    getUser(uid: string): Promise<firebase.auth.UserRecord> {
        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/admin/users/'+uid,{
            method:'GET',mode: "cors",credentials:"include",
            headers: this.apiHeader,
        })
        .then(response => response.json())
        .then(json =>{
            if (json['message']){
                this.emitter_.emit("error", json);
                return null;
            }
            else{
                const currentUser_ = new MockUser(json);
                return currentUser_;
            }            
        })
    }

    getUserByEmail(email: string): Promise<firebase.auth.UserRecord> {
        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/admin/users?'+'email='+email,{
            method:'GET',mode: "cors",credentials:"include",
            headers: this.apiHeader,
        })
        .then(response => response.json())        
        .then(json =>{
            if (json['message']){
                this.emitter_.emit("error", json);
                return null;
            }
            else{
                const currentUser_ = new MockUser(json);
                return currentUser_;
            }
            
        })
    }

    getUserByPhoneNumber(phoneNumber: string): Promise<firebase.auth.UserRecord> {

        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/admin/users?'+'phoneNumber='+phoneNumber,{
            method:'GET',mode: "cors",credentials:"include",
            headers: this.apiHeader,
        })
        .then(response => response.json())        
        .then(json =>{
            if (json['message']){
                this.emitter_.emit("error", json);
                return null;
            }
            else{
                const currentUser_ = new MockUser(json);
                return currentUser_;
            }
            
        })
    }

    listUsers(maxResults?: number, pageToken?: string): Promise<firebase.auth.ListUsersResult> {

        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/admin/list',{
            method:'POST',mode: "cors",
            headers: this.apiHeader,
            body: JSON.stringify({ startDate:0, endDate: Number.MAX_SAFE_INTEGER })
        })
        .then(response => response.json())        
        .then(data =>{
            return { users: data };
        })
    }

    onAuthStateChanged(
        nextOrObserver: any,
        errorCallback?: (error: firebase.auth.Error) => any,
        completedCallback?: () => any
    ): () => any {

        let nextCallback: Function;

        if (typeof nextOrObserver === "function") {
            errorCallback = errorCallback || (() => {});
            nextCallback = nextOrObserver;
        } else {
            errorCallback = (error: firebase.auth.Error) => { nextOrObserver["error"](error); };
            nextCallback = (value: firebase.User) => { nextOrObserver["next"](value); };
        }

        this.emitter_.on("auth", nextCallback as Listener);
        this.emitter_.on("error", errorCallback);

        setTimeout(() => this.emitter_.emit("auth", this.currentUser_), 0);

        return () => {
            this.emitter_.off("auth", nextCallback as Listener);
            this.emitter_.off("error", errorCallback as Listener);
        };
    }

    onIdTokenChanged(
        nextOrObserver: Object,
        error?: (error: firebase.auth.Error) => any,
        completed?: () => any
    ): () => any {

        return this.onAuthStateChanged(nextOrObserver, error, completed);
    }

    sendPasswordResetEmail(email: string): Promise<any> {

        throw unsupported_();
    }

    setCustomUserClaims(uid: string, customUserClaims: Object): Promise<void> {

        throw unsupported_();
    }

    setPersistence(persistence: firebase.auth.Auth.Persistence): Promise<any> {

        throw unsupported_();
    }

    signInAndRetrieveDataWithCredential(credential: firebase.auth.AuthCredential): Promise<any> {

        throw unsupported_();
    }

    signInAnonymously(): Promise<any> {

        this.currentUser_ = new MockUser({ email: undefined, uid: '' });
        this.emitter_.emit("auth", this.currentUser_);

        return Promise.resolve(this.currentUser_);
    }

    signInWithCredential(credential: firebase.auth.AuthCredential): Promise<any> {

        let identity = this.identities_.find((identity) => identity.credential === credential);
        if (identity) {
            this.currentUser_ = new MockUser(identity);
            this.emitter_.emit("auth", this.currentUser_); 
            return Promise.resolve(this.currentUser_);
        }
        else{            
            const loginData = { 
                email:credential.email, 
                password:credential.password, 
                activationToken: "3fa85f64-5717-4562-b3fc-2c963f66afa6"
            };
            const authURL = this.options_['authURL'];
            return fetch(authURL+'api/v1/login',{
                method:'POST',mode: "cors",
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(loginData),
            })
            .then(response => response.json())
            .then(json=>{
                if (json['message']){
                    this.emitter_.emit("error", json);
                }
                else{
                    this.currentUser_ = new MockUser(json);
                    this.accessToken_ = json['token'];
                    this.emitter_.emit("auth", this.currentUser_);
                }                
                return this.currentUser_;
            }).catch(e=>{
                return error_("auth/invalid-credential", "Invalid credential.");
            });
            
        }
    }

    signInWithCustomToken(token: string): Promise<any> {

        let identity = this.identities_.find((identity) => identity.token === token);
        if (identity) {
            this.currentUser_ = new MockUser(identity);
            this.emitter_.emit("auth", this.currentUser_);    
            return Promise.resolve(this.currentUser_); 
        }
        else{
            const authURL = this.options_['authURL'];
            return fetch(authURL+'api/v1/user',{
                method:'GET',mode: "cors",
                headers: {'Content-Type': 'application/json', 'Authorization': 'Token '+token},
            })
            .then(response => response.json())
            .then(json =>{
                if (json['message']){
                    this.emitter_.emit("error", json);
                }
                else{
                    this.currentUser_ = new MockUser(json);
                    this.accessToken_ = json['token'];
                    this.emitter_.emit("auth", this.currentUser_);
                }                
                return this.currentUser_;
            }).catch(e =>{
                return error_("auth/invalid-credential", "Invalid credential.");
            });
        }        
    }

    signInWithEmailAndPassword(email: string, password: string): Promise<any> {
        
        const identity = this.identities_.find((identity) => identity.email === email);
        if (identity) {
            if (identity.password !== password) {
                return Promise.reject(error_("auth/wrong-password", "Wrong password."));
            }
            this.currentUser_ = new MockUser(identity);
            this.emitter_.emit("auth", this.currentUser_);    
            return Promise.resolve(this.currentUser_);
        }
        else{
            const loginData = { email, password, activationToken: "3fa85f64-5717-4562-b3fc-2c963f66afa6"};
            const authURL = this.options_['authURL'];
            return fetch(authURL+'api/v1/login',{
                method:'POST',mode: "cors",
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(loginData),
            })
            .then(response => response.json())
            .then(json=>{
                if (json['message']){
                    this.emitter_.emit("error", json);
                }
                else{
                    this.currentUser_ = new MockUser(json);
                    this.accessToken_ = json['token'];
                    this.emitter_.emit("auth", this.currentUser_);
                }                
                return this.currentUser_;
            }).catch(e=>{
                return error_("auth/invalid-credential", "Invalid credential.");
            });
        }       

        
    }

    signInWithPhoneNumber(
        phoneNumber: string,
        applicationVerifier: firebase.auth.ApplicationVerifier
    ): Promise<any> {

        throw unsupported_();
    }

    signInWithPopup(provider: firebase.auth.AuthProvider): Promise<any> {

        throw unsupported_();
    }

    signInWithRedirect(provider: firebase.auth.AuthProvider): Promise<any> {

        throw unsupported_();
    }

    signOut(): Promise<any> {
        const uid = this.currentUser_?.uid;
        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/logout',{
            method:'GET',mode: "cors", credentials:"include",
            headers: this.apiHeader,
        })
        .then(response => response)
        .finally(() => {
            this.currentUser_ = null;
            this.accessToken_ = null;
            this.emitter_.emit("auth", this.currentUser_);
            return uid;
        })     
        
    }

    updateUser(uid: string, properties: firebase.auth.UpdateRequest): Promise<firebase.auth.UserRecord> {
        const authURL = this.options_['authURL'];
        return fetch(authURL+'api/v1/admin/user/'+uid,{
            method:'PUT',mode: "cors", credentials:"include",
            headers: this.apiHeader,
            body: JSON.stringify(properties)
        })        
        .then(response => response.json())        
        .then(json =>{
            if (json['message']){
                this.emitter_.emit("error", json);
                return null;
            }
            else{
                const currentUser_ = new MockUser(json);
                return currentUser_;
            }            
        })
    }

    updateProfile(
        currentUser: firebase.User,
        properties: firebase.auth.UpdateRequest   
    ): Promise<firebase.User> {
        const authURL = this.options_['authURL'];
        return currentUser.getToken().then((token) => {
            return fetch(authURL+'api/v1/profile/save',{
                method:'POST',mode: "cors",credentials:"include",
                headers: {'Content-Type': 'application/json', 'Authorization': 'Token ' + token},
                body: JSON.stringify(properties)
            })        
            .then(response => response.json())        
            .then(json =>{
                if (json['message']){
                    this.emitter_.emit("error", json);
                    return currentUser;
                }
                else{
                    const newUser = new MockUser(json);
                    return newUser;
                }            
            })
        })
        
    }

    useDeviceLanguage(): any {

        throw unsupported_();
    }

    verifyIdToken(idToken: string): Promise<firebase.auth.DecodedIdToken> {

        throw unsupported_();
    }

    verifyPasswordResetCode(code: string): Promise<any> {

        throw unsupported_();
    }
}
