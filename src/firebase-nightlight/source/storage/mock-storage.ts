/**
 * @license Use of this source code is governed by a GPL-3.0 license that
 * can be found in the LICENSE file at https://github.com/cartant/firebase-nightlight
 */

import { firebase } from "../firebase";
import { error_, unsupported_ } from "../mock-error";
import { MockStorageBucket } from "./storage-bucket";
import { MockStorageReference } from "./storage-reference";
import { S3Client } from "@aws-sdk/client-s3"
import { AuthScheme, AwsCredentialIdentity, ChecksumConstructor, Logger, MemoizedProvider, Provider, RegionInfoProvider, RequestSigner } from "@smithy/types";

export interface MockStorageOptions {
    app: firebase.app.App;
    url?: string;
    bucket?: string;
    endpoint?: string;
    region?: string;
    credentials?: AwsCredentialIdentity    
}


export class MockStorage implements firebase.storage.Storage {

    private app_: firebase.app.App;
    private url_: string;
    private bucket_: string;
    private refs: firebase.storage.ReferenceDictionary;
    private root_: firebase.storage.Reference;
    private client_: S3Client;
    private options_: MockStorageOptions

    constructor(options: MockStorageOptions) {
        this.refs = {}
        this.app_ = options.app;
        this.options_ = options;
        this.url_ = options.url || '/';
        this.bucket_ = options.bucket || 'default';
        this.client_ = new S3Client(options);
        this.root_ = new MockStorageReference(this, null, null, this.bucket_, '/');
    }

    get app(): firebase.app.App {

        return this.app_;
    }

    get maxOperationRetryTime(): number {       
        const maxAttempts = this.client_.config.maxAttempts;
        if (maxAttempts){
            let number = 0;
            maxAttempts().then(t=>{
                number = t;
            })
            return number;
        }
        return 0;
    }

    get maxUploadRetryTime(): number {

        throw unsupported_();
    }

    get client(): S3Client {
        return this.client_;
    }

    get options(): MockStorageOptions {
        return this.options_;
    }

    bucket(name: string): any {
        return new MockStorageBucket(this, name);
    }

    root(): firebase.storage.Reference {
        return this.root_;
    }

    ref(path?: string): firebase.storage.Reference {
        if(!path) path = this.url_;
        // replace multiple consecutive slashs with single slash
        path = path.replace(/\/+/g,'/');

        // replace leading slash
        path = path.replace(/^\//g,'');

        // replace trailing slash
        path = path.replace(/\/$/g,'');

        // get all paths
        let paths: string[] = path.split('/');

        // create root reference
        let rootPath = paths.shift() as string;
        if (!this.refs[rootPath]) {
            this.refs[rootPath] = new MockStorageReference(this, this.root(), null, this.bucket_, '/'+rootPath);
        }

        if (paths.length === 0) {
            return this.refs[rootPath];
        } else {
            return this.refs[rootPath].child(paths.join('/'));
        }
    }

    refFromURL(url: string): firebase.storage.Reference {
        const endpointstruct = new URL(this.client_.config.endpoint as string);
        const urlstruct = new URL(url);
        let path = urlstruct.pathname;
        if (path.startsWith(endpointstruct.pathname)){
            path = path.substring(endpointstruct.pathname.length)
        }
        return this.ref(path);   
    }

    setMaxOperationRetryTime(time: number): any {
        this.client_.config.maxAttempts.apply(time);
    }

    setMaxUploadRetryTime(time: number): any {
        this.client_.config.maxAttempts.apply(time);
    }
}
