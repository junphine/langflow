/**
 * @license Use of this source code is governed by a GPL-3.0 license that
 * can be found in the LICENSE file at https://github.com/cartant/firebase-nightlight
 */

import { firebase } from "../firebase";

export type MockDocumentPrimitive = boolean | number | string;
export type MockDocumentComposite = { [key: string]: MockDocumentPrimitive | MockDocumentComposite };
export type MockDocumentValue = MockDocumentPrimitive | MockDocumentComposite;

export type MockCollection = { [id: string]: MockDocument };
export type MockDocument = {
    collections: { [id: string]: MockCollection },
    data: MockDocumentComposite
};
export type MockDocumentPair = {
    doc: MockDocument;
    id: string;
};

export type MockFieldPath = { [key: string]: firebase.firestore.FieldPath };
export type MockFieldValue = { [key: string]: firebase.firestore.FieldValue };

export interface MockFirestoreQuery {
    endAt?: any[];
    endBefore?: any[];
    limit?: number;
    orderByDirection?: firebase.firestore.OrderByDirection;
    orderByField?: string;
    startAfter?: any[];
    startAt?: any[];
    where: {
        field?: string;
        operator?: firebase.firestore.WhereFilterOp;
        value?: any;
    }[];
}

export type MockFirestoreContent = { [id: string]: MockCollection };
