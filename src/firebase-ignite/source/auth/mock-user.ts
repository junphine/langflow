/**
 * @license Use of this source code is governed by a GPL-3.0 license that
 * can be found in the LICENSE file at https://github.com/cartant/firebase-nightlight
 */

import { firebase } from "../firebase";
import { unsupported_ } from "../mock-error";
import { randomString } from "../text-random-string";

export interface MockUserOptions {
    email?: string;
    uid?: string;
    phoneNumber?: string;
    photoURL?: string;
    isAdmin?: boolean;
}

export class MockUser implements firebase.User,firebase.auth.UserRecord{
    //- private auth: firebase.auth.Auth;

    public displayName: string | null;
    public email: string;
    public emailVerified: boolean;
    public isAdmin: boolean;
    public metadata: firebase.auth.UserMetadata;
    public phoneNumber: string | null;
    public photoURL: string | null;
    public providerData: (firebase.UserInfo | null)[];
    public providerId: string;
    public refreshToken: string;
    public uid: string;

    token: string | null;
    disabled: boolean;
    passwordHash?: string | undefined;
    passwordSalt?: string | undefined;
    customClaims?: Object | undefined;

    constructor(options: MockUserOptions | any) {

        const alphabet = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmonpqrstuvwxyz0123456789";
        const email = options.email as string;
        const uid = options.uid || options.email;
        const name = options.firstName && options.lastName && options.firstName + ' ' + options.lastName
        this.displayName = options.displayName || name || email;
        this.email = email;
        this.emailVerified = false;
        this.isAdmin = options.isAdmin || options.admin || false;        
        this.phoneNumber = options.phoneNumber as string || options.phone;
        this.photoURL = options.photoURL || options.avatar || null;

        this.metadata = { toJSON(): string { return JSON.stringify(this); } };

        this.providerData = [{
            displayName: this.displayName,
            email,
            phoneNumber: this.phoneNumber,
            photoURL: this.photoURL,
            providerId: "password",
            uid
        }];
        this.providerId = "password";
        this.refreshToken = options.refreshToken || options.activationTok;
        this.uid = uid;
        this.disabled = options.disabled || false;
        this.token = options.token || options.tok;
    }    

    delete(): Promise<any> {
        this.disabled = true;
        return Promise.resolve(this);
    }

    getIdToken(forceRefresh?: boolean): Promise<any> {

        return Promise.resolve(this.token);
    }

    getToken(forceRefresh?: boolean): Promise<any> {

        return Promise.resolve(this.token);
    }

    link(credential: firebase.auth.AuthCredential): Promise<any> {

        throw unsupported_();
    }

    linkAndRetrieveDataWithCredential(credential: firebase.auth.AuthCredential): Promise<any> {

        throw unsupported_();
    }

    linkWithCredential(credential: firebase.auth.AuthCredential): Promise<any> {

        throw unsupported_();
    }

    linkWithPhoneNumber(
        phoneNumber: string,
        applicationVerifier: firebase.auth.ApplicationVerifier
    ): Promise<any> {

        throw unsupported_();
    }

    linkWithPopup(provider: firebase.auth.AuthProvider): Promise<any> {

        throw unsupported_();
    }

    linkWithRedirect(provider: firebase.auth.AuthProvider): Promise<any> {

        throw unsupported_();
    }

    reauthenticate(credential: firebase.auth.AuthCredential): Promise<any> {

        throw unsupported_();
    }

    reauthenticateAndRetrieveDataWithCredential(credential: firebase.auth.AuthCredential): Promise<any> {

        throw unsupported_();
    }

    reauthenticateWithCredential(credential: firebase.auth.AuthCredential): Promise<any> {

        throw unsupported_();
    }

    reauthenticateWithPhoneNumber(
        phoneNumber: string,
        applicationVerifier: firebase.auth.ApplicationVerifier
    ): Promise<any> {

        throw unsupported_();
    }

    reauthenticateWithPopup(provider: firebase.auth.AuthProvider): Promise<any> {

        throw unsupported_();
    }

    reauthenticateWithRedirect(provider: firebase.auth.AuthProvider): Promise<any> {

        throw unsupported_();
    }

    reload(): Promise<any> {

        throw unsupported_();
    }

    sendEmailVerification(): Promise<any> {

        throw unsupported_();
    }

    toJSON(): Object {

        return {
            displayName: this.displayName,
            email: this.email,
            emailVerified: this.emailVerified,
            isAdmin: this.isAdmin,
            metadata: this.metadata,
            phoneNumber: this.phoneNumber,
            photoURL: this.photoURL,        
            refreshToken: this.refreshToken,
            uid: this.uid
        };
    }

    unlink(providerId: string): Promise<any> {

        throw unsupported_();
    }

    updateEmail(email: string): Promise<any> {

        throw unsupported_();
    }

    updatePassword(password: string): Promise<any> {

        this.passwordHash = password;
        return Promise.resolve(this);
    }

    updatePhoneNumber(phoneCredential: firebase.auth.AuthCredential): Promise<any> {
        
        this.phoneNumber = phoneCredential.phoneNumber;
        return Promise.resolve(this);
    }

    updateProfile(
        profile: { displayName: string | null, photoURL: string | null }        
    ): Promise<any> {

        this.displayName = profile.displayName;
        this.photoURL = profile.photoURL;
        return Promise.resolve(this);
    }

    commitChanges(auth: firebase.auth.Auth) : Promise<any>{
        return auth.updateProfile(this,this);
    }
}
