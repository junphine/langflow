import { firebase } from "../firebase";
import { error_, unsupported_ } from "../mock-error";
import { S3Client, PutObjectCommand,DeleteObjectsCommand,ServiceOutputTypes } from "@aws-sdk/client-s3"

export class MockUploadTask implements firebase.storage.UploadTask{
  private task: Promise<ServiceOutputTypes>;

  cancel(): boolean {
    throw new Error("Method not implemented.");
  }
  catch(onRejected: (a: Error) => any): Promise<any> {    
    return this.task.catch(onRejected);
  }
  on(event: string, nextOrObserver?: firebase.Observer<any, any> | ((a: Object) => any) | null | undefined, error?: ((a: Error) => any) | null | undefined, complete?: firebase.Unsubscribe | null | undefined): Function {
    throw new Error("Method not implemented.");
  }
  pause(): boolean {
    throw new Error("Method not implemented.");
  }
  resume(): boolean {
    throw new Error("Method not implemented.");
  }
  snapshot: firebase.storage.UploadTaskSnapshot | null;
  then(onFulfilled?: ((a: firebase.storage.UploadTaskSnapshot) => any) | null | undefined, onRejected?: ((a: Error) => any) | null | undefined): Promise<any> {
    return this.task.then(
      (output: ServiceOutputTypes) => { 
        this.snapshot = {
          metadata:output.$metadata,
          //task: this
        } as firebase.storage.UploadTaskSnapshot;

        if(onFulfilled) onFulfilled(this.snapshot); 
      },
      onRejected);
  }

  public constructor(task: Promise<ServiceOutputTypes>){
    this.task = task;
    this.snapshot = null;
  }
  
}

export class MockStorageReference implements firebase.storage.Reference{  
  storage: firebase.storage.Storage;
  bucket: string;
  name: string;
  root: firebase.storage.Reference | null;
  parent: firebase.storage.Reference | null;
  fullPath: string;
  _children: firebase.storage.ReferenceDictionary;
  
  
  child(path: string): firebase.storage.Reference {
    // replace multiple consecutive slashs with single slash
    path = path.replace(/\/+/g,'/');

    // replace leading slash
    path = path.replace(/^\//g,'');

    // replace trailing slash
    path = path.replace(/\/$/g,'');

    // get all paths
    let paths:string[] = path.split('/');

    // create child reference
    let childPath:string = paths.shift() as string;
    if (!this._children[childPath]) {
      this._children[childPath] = new MockStorageReference(this.storage, this.root, this, this.bucket, childPath);
    }

    if (paths.length === 0) {
      return this._children[childPath];
    } else {
      return this._children[childPath].child(paths.join('/'));
    }
  }

  delete(): Promise<any> {
    const client = this.storage.client as S3Client;
    const input = { // DeleteObjectsRequest
      Bucket: this.name,
      Delete: { // Delete
        Objects: [ // ObjectIdentifierList // required
          { // ObjectIdentifier
            Key: this.fullPath, // required            
          },
        ],
        Quiet: true,
      },     
    };
    const command = new DeleteObjectsCommand(input);
    return client.send(command);
  }
  
  getDownloadURL(): Promise<any> {
    const client = this.storage.client as S3Client;
    const endpont = client.config.endpoint;
    if (endpont){
      return endpont().then(e=>{
        return e.protocol + '//' +e.hostname + ':' + e.port + e.path + this.bucket + this.fullPath
      })
    }
    else{
      return Promise.resolve(this.storage.options['endpont'] + this.bucket + this.fullPath);
    }    
  }
  
  getMetadata(): Promise<any> {
    throw new Error("Method not implemented.");
  }

  uploadBytes(file: any): firebase.storage.UploadTask {    
    return this.put(file);
  }

  put(data: any, metadata?: firebase.storage.UploadMetadata | undefined): firebase.storage.UploadTask {
    const client = this.storage.client as S3Client;
    const params = {
      Bucket: this.bucket, // The name of the bucket. For example, 'sample_bucket_101'.
      Key: `${this.fullPath}`, // The name of the object. For example, 'sample_upload.txt'.
    };
    
    const resp = client.send(new PutObjectCommand({ Body: data, ...params }));
    return new MockUploadTask(resp);
  }

  putString(data: string, format?: string | undefined, metadata?: firebase.storage.UploadMetadata | undefined): firebase.storage.UploadTask {
    const client = this.storage.client as S3Client;
    const params = {
      Bucket: this.bucket, // The name of the bucket. For example, 'sample_bucket_101'.
      Key: `${this.fullPath}`, // The name of the object. For example, 'sample_upload.txt'.
      ContentType: format
    };
    
    const resp = client.send(new PutObjectCommand({ Body: data, ...params }));
    return new MockUploadTask(resp);
  }

  toString(): string {
    throw new Error("Method not implemented.");
  }
  updateMetadata(metadata: firebase.storage.SettableMetadata): Promise<any> {
    throw new Error("Method not implemented.");
  }
    
  constructor(storage: firebase.storage.Storage,root: firebase.storage.Reference | null, parent: firebase.storage.Reference | null, bucket:string, name:string){
    this.storage = storage;
    this.root = root;
    this.parent = parent;
    this.bucket = bucket;
    this.name = name;
    this.fullPath = parent? parent.fullPath+'/'+name : name;
    this._children = {};
  }
}