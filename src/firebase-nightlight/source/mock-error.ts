/**
 * @license Use of this source code is governed by a GPL-3.0 license that
 * can be found in the LICENSE file at https://github.com/cartant/firebase-nightlight
 */
import * as firebase from "./firebase-interfaces";

export function toError(value: any): Error {
    
    const error = new Error((typeof value === "string") ?
        value :
        value.message || "Unknown message."
    ) as any;
    error["code"] = value.code || "unknown/code";
    return error;
}

export function error_(code: string, message: string): Error {

    const error = new Error(message || "Unknown error.") as any;
    error.code = code;
    return error;
}

export function unsupported_(message?: string): Error {

    const error = new Error(message || "Not supported.");
    return error;
}
