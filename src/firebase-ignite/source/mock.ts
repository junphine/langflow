/**
 * @license Use of this source code is governed by a GPL-3.0 license that
 * can be found in the LICENSE file at https://github.com/cartant/firebase-nightlight
 */

import { firebase } from "./firebase";
import { MockOptions, MockUntyped } from "./mock-untyped";

export { MockOptions };

export class Mock {

    private untyped_: MockUntyped;

    constructor(options?: MockOptions) {

        const firestore = (options && options.firestore) ? {
            fieldPath: {
                documentId: firebase.firestore.FieldPath.documentId()
            },
            fieldValue: {
                delete: firebase.firestore.FieldValue.delete(),
                serverTimestamp: firebase.firestore.FieldValue.serverTimestamp()
            },
            ...options.firestore
        } : {};

        this.untyped_ = new MockUntyped({
            ...options,
            ...firestore
        });
    }

    get apps(): (firebase.app.App | null)[] {

        return this.untyped_.apps;
    }

    get SDK_VERSION(): string {

        return this.untyped_.SDK_VERSION;
    }

    app(name?: string): firebase.app.App {

        return name ? this.untyped_.app() : this.untyped_.app(name);
    }

    auth(app?: firebase.app.App): firebase.auth.Auth {

        return !app ? this.untyped_.auth() : this.untyped_.auth(app);
    }

    database(app?: firebase.app.App): firebase.database.Database {

        return !app ? this.untyped_.database() : this.untyped_.database(app);
    }

    firestore(app?: firebase.app.App): firebase.firestore.Firestore {

        return !app ? this.untyped_.firestore() : this.untyped_.firestore(app);
    }

    initializeApp(options: any, name?: string): firebase.app.App {

        return name ? this.untyped_.initializeApp(options, name) : this.untyped_.initializeApp(options);
    }

    messaging(app?: firebase.app.App): firebase.messaging.Messaging {

        return !app ? this.untyped_.messaging() : this.untyped_.messaging(app);
    }

    storage(app?: firebase.app.App): firebase.storage.Storage {

        return !app ? this.untyped_.storage() : this.untyped_.storage(app);
    }
}
