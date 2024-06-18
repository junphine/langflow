/**
 * @license Use of this source code is governed by a GPL-3.0 license that
 * can be found in the LICENSE file at https://github.com/cartant/firebase-nightlight
 */

import { EventEmitter2, Listener } from "eventemitter2";
import { firebase } from "../firebase";
import * as json from "../json";
import * as lodash from "../lodash";
import { unsupported_ } from "../mock-error";
import { MockEmitters } from "../mock-types";
import { toObserver } from "../observer";
import { MockCollectionRef } from "./mock-collection-ref";
import { MockDocumentSnapshot } from "./mock-document-snapshot";
import { toJsonPath, toPath, toSlashPath, validateFields, validatePath } from "./mock-firestore-paths";
import { MockFieldPath, MockFieldValue, MockFirestoreContent } from "./mock-firestore-types";
import { DocumentStore } from "./document_store";

export interface MockDocumentRefOptions {
    app: firebase.app.App;
    emitters: MockEmitters;
    fieldPath: MockFieldPath;
    fieldValue: MockFieldValue;
    firestore: firebase.firestore.Firestore;
    path: string;
    store: { content: MockFirestoreContent, proxy: DocumentStore};
}

export class MockDocumentRef implements firebase.firestore.DocumentReference {

    public readonly jsonPath_: string;

    private app_: firebase.app.App;
    private emitters_: MockEmitters;
    private fieldPath_: MockFieldPath;
    private fieldValue_: MockFieldValue;
    private firestore_: firebase.firestore.Firestore;
    private id_: string;
    private parentPath_: string;
    private path_: string;
    private refEmitter_: EventEmitter2;
    private rootEmitter_: EventEmitter2;
    private sharedEmitter_: EventEmitter2;
    private store_: { content: MockFirestoreContent, proxy: DocumentStore };

    constructor(options: MockDocumentRefOptions) {

        this.app_ = options.app;
        this.emitters_ = options.emitters;
        this.fieldPath_ = options.fieldPath;
        this.fieldValue_ = options.fieldValue;
        this.firestore_ = options.firestore;
        this.store_ = options.store;

        this.path_ = toPath(options.path);
        validatePath(this.path_);
        this.jsonPath_ = toJsonPath(this.path_);

        const index = this.path_.lastIndexOf("/");
        this.id_ = this.path_.substring(index + 1);
        this.parentPath_ = this.path_.substring(0, index);

        this.refEmitter_ = new EventEmitter2();
        this.rootEmitter_ = this.emitters_.root;
        this.sharedEmitter_ = this.emitters_.shared[this.jsonPath_];
        if (!this.sharedEmitter_) {
            this.sharedEmitter_ = new EventEmitter2({ wildcard: true });
            this.emitters_.shared[this.jsonPath_] = this.sharedEmitter_;
        }
        this.sharedEmitter_.onAny(this.sharedListener_.bind(this));
    }

    public get firestore(): firebase.firestore.Firestore {

        return this.firestore_;
    }

    public get id(): string {

        return this.id_;
    }

    public get parent(): firebase.firestore.CollectionReference {

        return new MockCollectionRef({
            app: this.app_,
            emitters: this.emitters_,
            fieldPath: this.fieldPath_,
            fieldValue: this.fieldValue_,
            firestore: this.firestore_,
            path: this.parentPath_,
            store: this.store_
        });
    }

    public get path(): string {

        return this.path_;
    }

    public get proxy(): DocumentStore {

        return this.store_.proxy;
    }

    public async emitChange() {
        if (!this.emitters_.shared) {
          return;
        }    
        const snapshot = await this.get();        
    }

    public collection(collectionPath: string): firebase.firestore.CollectionReference {

        return new MockCollectionRef({
            app: this.app_,
            emitters: this.emitters_,
            fieldPath: this.fieldPath_,
            fieldValue: this.fieldValue_,
            firestore: this.firestore_,
            path: json.join(this.path_, collectionPath),
            store: this.store_
        });
    }

    public delete(): Promise<void> {

        const previousContent = this.store_.content;

        const error = json.findError(this.jsonPath_, this.store_.content);
        if (error) {
            return Promise.reject(error);
        }

        return this.proxy.deleteDocument(this.parentPath_,this.id_)
        .then(pair=>{
            this.store_.content = json.remove(
                this.store_.content,
                json.join(this.jsonPath_, "data")
            );

            this.rootEmitter_.emit("content", {
                content: this.store_.content,
                previousContent
            });
        });        
    }

    public get(): Promise<firebase.firestore.DocumentSnapshot> {
        return this.proxy.loadDocument(this.parentPath_,this.id_)
        .then(pair=>{
            this.store_.content[this.parentPath_] = this.store_.content[this.parentPath_] || {}          
            this.store_.content[this.parentPath_][pair.id] = pair.doc;
            const snap = new MockDocumentSnapshot({
                content: this.store_.content,
                ref: this
            })
            return snap;
        })
        
    }

    public isEqual(other: firebase.firestore.DocumentReference): boolean {

        return this.path === other.path;
    }

    public onSnapshot(observer: {
        next?: (snapshot: firebase.firestore.DocumentSnapshot) => void;
        error?: (error: firebase.firestore.FirestoreError) => void;
        complete?: () => void;
    }): () => void;
    public onSnapshot(
        options: firebase.firestore.DocumentListenOptions,
        observer: {
            next?: (snapshot: firebase.firestore.DocumentSnapshot) => void;
            error?: (error: Error) => void;
            complete?: () => void;
        }
    ): () => void;
    public onSnapshot(
        onNext: (snapshot: firebase.firestore.DocumentSnapshot) => void,
        onError?: (error: Error) => void,
        onCompletion?: () => void
    ): () => void;
    public onSnapshot(
        options: firebase.firestore.DocumentListenOptions,
        onNext: (snapshot: firebase.firestore.DocumentSnapshot) => void,
        onError?: (error: Error) => void,
        onCompletion?: () => void
    ): () => void;
    public onSnapshot(...args: any[]): () => void {

        let options: firebase.firestore.DocumentListenOptions;
        let observer = toObserver(...args);

        if (observer) {
            options = {};
        } else {
            let rest: any[];
            [options, ...rest] = args;
            observer = toObserver(...rest);
        }

        if (options.includeMetadataChanges) {
            throw unsupported_();
        }

        Promise.resolve().then(() => observer.next(new MockDocumentSnapshot({
            content: this.store_.content,
            ref: this
        })));

        const listener = (snapshot: firebase.firestore.DocumentSnapshot) => {
            observer.next(snapshot);
        };
        this.refEmitter_.on("snapshot", listener);
        return () => this.refEmitter_.off("snapshot", listener);
    }

    public set(
        data: firebase.firestore.DocumentData,
        options?: firebase.firestore.SetOptions
    ): Promise<void> {

        const previousContent = this.store_.content;

        validateFields(data);
        data = json.clone(data);

        const error = json.findError(this.jsonPath_, this.store_.content);
        if (error) {
            return Promise.reject(error);
        }

        return this.proxy.addDocument(this.parentPath_,this.id_, data)
        .then(pair=>{     

            if (options && options.merge) {
                this.store_.content = mergeData(
                    this.store_.content,
                    json.join(this.jsonPath_, "data"),
                    this.fieldValue_,
                    data
                );
            } else {
                this.store_.content = json.set(
                    this.store_.content,
                    json.join(this.jsonPath_, "data"),
                    data
                );
            }

            this.rootEmitter_.emit("content", {
                content: this.store_.content,
                previousContent
            });
        });
    }

    public update(data: firebase.firestore.UpdateData): Promise<void>;
    public update(
        field: string | firebase.firestore.FieldPath,
        value: any,
        ...moreFieldsAndValues: any[]
    ): Promise<void>;
    public update(...args: any[]): Promise<void> {

        const previousContent = this.store_.content;
        let data: firebase.firestore.DocumentData;

        if (args.length === 1) {
            [data] = args;
        } else {
            data = {};
            for (let a = 0; a < args.length; a += 2) {
                if (typeof args[a] !== "string") {
                    throw unsupported_();
                }
                data[args[a]] = args[a + 1];
            }
        }
        validateFields(data);
        data = json.clone(data);

        const error = json.findError(this.jsonPath_, this.store_.content);
        if (error) {
            return Promise.reject(error);
        }

        return this.proxy.updateDocument(this.parentPath_,this.id_, data)
        .then(pair=>{

            this.store_.content = mergeData(
                this.store_.content,
                json.join(this.jsonPath_, "data"),
                this.fieldValue_,
                data
            );

            this.rootEmitter_.emit("content", {
                content: this.store_.content,
                previousContent
            });
        });
    }

    private sharedListener_(
        eventType: string,
        { content }: { content: MockFirestoreContent }
    ): void {

        this.refEmitter_.emit("snapshot", new MockDocumentSnapshot({
            content,
            ref: this
        }));
    }
}

function mergeData(
    content: any,
    path: string,
    fieldValue: MockFieldValue,
    data: firebase.firestore.DocumentData
): any {

    const deleteFieldValue = fieldValue["delete"];

    lodash.each(data, (value:any, key: string) => {

        const slashPath = toSlashPath(key);
        const jsonPath = toJsonPath(json.join(path, slashPath));
        const error = json.findError(jsonPath, content);
        if (error) {
            throw error;
        }

        if (value === deleteFieldValue) {
            content = json.remove(
                content,
                jsonPath
            );
            json.prune(content, jsonPath);
        } else {
            content = json.set(
                content,
                jsonPath,
                json.clone(value)
            );
        }
    });
    return content;
}
