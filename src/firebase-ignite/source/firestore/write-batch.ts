import { firebase } from "../firebase";
import { MockDocumentRef as MockDocumentReference,MockDocumentRefOptions } from "./mock-document-ref";
import { MockFirestore } from "./mock-firestore";

type OperationDocPair = {
  doc: MockDocumentReference;
  execute(doc: MockDocumentReference): Promise<void>;
};

export class MockWriteBatch implements firebase.firestore.WriteBatch {
  private readonly operations: OperationDocPair[] = [];

  constructor(private readonly firestore: MockFirestore) {}

  set(
    doc: MockDocumentReference,
    data: firebase.firestore.DocumentData,
    options?: firebase.firestore.SetOptions | undefined
  ): firebase.firestore.WriteBatch {
    this.operations.push({ doc, execute: (doc) => doc.set(data, options) });
    return this;
  }

  update(
    documentRef: firebase.firestore.DocumentReference,
    data: firebase.firestore.UpdateData
  ): firebase.firestore.WriteBatch;

  update(
    documentRef: firebase.firestore.DocumentReference,
    field: string | firebase.firestore.FieldPath,
    value: any,
    ...moreFieldsAndValues: any[]
  ): firebase.firestore.WriteBatch;

  update(doc: MockDocumentReference, data: any, value?: any, ...rest: any[]) {
    this.operations.push({ doc, execute: (doc) => doc.update(data, value, ...rest) });
    return this;
  }

  delete(doc: MockDocumentReference): firebase.firestore.WriteBatch {
    this.operations.push({ doc, execute: (doc) => doc.delete() });
    return this;
  }

  async commit() {
    const affectedDocs:Set<string> = new Set<string>();
    while (this.operations.length) {
      const { doc, execute } = this.operations.shift()!;
      const beforeOperation = await doc.get();
      
      await execute(doc);

      const afterOperation:firebase.firestore.DocumentSnapshot = await doc.get();
      // If state before and after changed, then it's a path which should have events emitted
      // after all operations are completed
      if (!afterOperation.isEqual(beforeOperation)) {
        affectedDocs.add(doc.path);
      }
    }

    for (const path of affectedDocs) {
      this.firestore.doc(path).emitChange();
    }
  }
}
