import { firebase } from "../firebase";
import { error_, unsupported_ } from "../mock-error";
import { MockStorageFile } from "./storage-file";
import { S3Client, HeadObjectCommand, GetObjectCommand,GetObjectOutput,ListObjectsV2Command } from "@aws-sdk/client-s3"

export class MockStorageBucket {
    storage: firebase.storage.Storage;
    name: string;
    constructor(storage: firebase.storage.Storage,name:string){
        this.storage = storage;     
        this.name = name;        
    }

    async file(fullPath: string): Promise<MockStorageFile>{
        const client = this.storage.client as S3Client;
        const input = { // GetObjectRequest
            Bucket: this.name, // required            
            Key: fullPath, // required           
          };
        const command = new HeadObjectCommand(input);
        const r = await client.send(command);
        
        return new MockStorageFile(this.name,fullPath,r);
    }

    fileStream(fullPath: string): Promise<GetObjectOutput>{
        const client = this.storage.client as S3Client;
        const input = { // GetObjectRequest
            Bucket: this.name, // required            
            Key: fullPath, // required           
          };
        const command = new GetObjectCommand(input);
        const r = client.send(command);        
        return r;
    }

    async list(): Promise<MockStorageFile[]> {
        const client = this.storage.client as S3Client;
        const command = new ListObjectsV2Command({
            Bucket: this.name,
            // The default and maximum number of keys returned is 1000. This limits it to
            // one for demonstration purposes.
            MaxKeys: 100,
        });
        const { Contents, IsTruncated, NextContinuationToken } = await client.send(command);
        if (!Contents){
            return [];
        }
        const contentsList = Contents.map((c) => {
           return new MockStorageFile(this.name,c.Key || '/',c);
        });           
        return contentsList;
    };
}