import { firebase } from "../firebase";
import { MockCollection, MockFieldPath, MockFieldValue, MockFirestoreContent,MockDocumentPair, MockDocumentComposite } from "./mock-firestore-types";

export class DocumentStore {
    
    private settings_: firebase.firestore.Settings;
    private accessToken_: string | undefined;

    constructor(settings: firebase.firestore.Settings){       
        this.settings_ = settings;
        this.accessToken_ = undefined;
    }

    get apiHeader(): HeadersInit {
        if (this.accessToken_){
            return {'content-type': 'application/json', 'Authorization': 'Token '+this.accessToken_};
        }            
        else {
            return {'content-type': 'application/json'};
        }        
    }

    addDocument(path: string, id: string, data: MockDocumentComposite): Promise<MockDocumentPair> {
        const dataURL = this.settings_.endpoint + '' + path + '/' + id
        return fetch(dataURL,{
            method:'POST',
            headers: this.apiHeader,
            body: JSON.stringify(data),
        })
        .then(response => response.json())        
        .then((row: MockDocumentComposite )=>{
            let _id = row['_id'] as string;            
            return {id: id, doc: { data: row, collections: {} }};                     
        })
    }

    loadAllDocuments(path: string): Promise<MockDocumentPair[]> {
        const dataURL = this.settings_.endpoint + '' + path
        return fetch(dataURL,{
            method:'GET',
            headers: this.apiHeader,
        })
        .then(response => response.json())
        .then(json => json['data'])
        .then((rows: MockDocumentComposite[] )=>{
            const pairs: MockDocumentPair[] = rows.map((row) =>{
                let id = row['_id'] as string;
                if(id.startsWith(path.slice(1)+'/')){
                    id = id.substring(path.length);                    
                }
                return {id: id, doc: { data: row, collections: {} }};
            });

            return pairs;            
        })
    }


    loadDocument(path: string, id: string): Promise<MockDocumentPair> {
        const dataURL = this.settings_.endpoint + '' + path + '/' + id
        return fetch(dataURL,{
            method:'GET',
            headers: this.apiHeader,
        })
        .then(response => response.json())        
        .then((row: MockDocumentComposite )=>{
            row['_id'] = path + '/' + id;
            return {id: id, doc: { data: row, collections: {} }};                      
        })
    }

    deleteDocument(path: string, id: string): Promise<MockDocumentPair> {
        const dataURL = this.settings_.endpoint + '' + path + '/' + id
        return fetch(dataURL,{
            method:'DELETE',
            headers: this.apiHeader,
        })
        .then(response => response.json())        
        .then((row: MockDocumentComposite )=>{
            const path = row['data'] as string;
            return {id: id, doc: { data: null, collections: {} }};                     
        })
    }

    updateDocument(path: string, id: string, data: MockDocumentComposite): Promise<MockDocumentPair> {
        const dataURL = this.settings_.endpoint + '' + path + '/' + id
        return fetch(dataURL,{
            method:'PUT',
            headers: this.apiHeader,
            body: JSON.stringify(data),
        })
        .then(response => response.json())        
        .then((row: MockDocumentComposite )=>{
            const path = row['data'] as string;
            return {id: id, doc: { data: data, collections: {} }};                     
        })
    }
   

}