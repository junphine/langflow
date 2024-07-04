import { firebase } from "../firebase";
import { error_, unsupported_ } from "../mock-error";
import { GetObjectOutput,HeadObjectOutput} from "@aws-sdk/client-s3"

export class MockStorageFile implements firebase.storage.FullMetadata{
  bucket: string;
  downloadURLs: string[];
  fullPath: string;
  generation: string;
  metageneration: string;
  name: string;
  size: number;
  timeCreated: string;
  updated: string;
  md5Hash?: string | null | undefined;
  cacheControl?: string | null | undefined;
  contentDisposition?: string | null | undefined;
  contentEncoding?: string | null | undefined;
  contentLanguage?: string | null | undefined;
  contentType?: string | null | undefined;
  customMetadata?: { [key: string]: string; } | null | undefined;

  constructor(bucket: string,fullPath:string,output:HeadObjectOutput | GetObjectOutput){
    this.bucket = bucket;     
    this.fullPath = fullPath;
    let paths:string[] = fullPath.split('/');
    this.name = paths[paths.length-1];
    const downloads = [output.WebsiteRedirectLocation] as string[]
    this.downloadURLs = downloads;
    this.size = output.ContentLength || 0;
    this.timeCreated = output.Expires?.toDateString() || '';
    this.updated = output.LastModified?.toDateString() || '';
    this.generation = output.VersionId || '';
    this.metageneration = output.ETag || '';
    this.md5Hash = output.ChecksumSHA256;

    this.customMetadata = output.Metadata;
    this.contentEncoding = output.ContentEncoding;
    this.cacheControl = output.CacheControl;
    this.contentDisposition = output.ContentDisposition;
    this.contentLanguage = output.ContentLanguage;
    this.contentType = output.ContentType;
    
  }

}