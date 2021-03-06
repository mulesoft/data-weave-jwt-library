/**
* This module provides functionality to create signed JSON Web Tokens using HMAC.
*
* The supported HMAC algorithms are:
*  - HS256
*  - HS384
*  - HS512
*/
%dw 2.0
import HMACBinary from dw::Crypto
import fail from dw::Runtime
import jwt::Common

/**
* Supported HMAC algorithms.
*/
var algMapping = {
    "HmacSHA256": "HS256",
    "HmacSHA384": "HS384",
    "HmacSHA512": "HS512"
}

/**
* Helper function to validate algorithm provided for signing.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `algorithm` | `String` | Algorithm provided for signing.
* |===
*
*/
fun alg(algorithm: String) : String | Null =
    algMapping[algorithm] default fail('Invalid algorithm provided for signing')

/**
* Helper function to sign the JWT.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `content` | `String` | JWT content.
* | `key` | `String` | Signing key.
* | `alg` | `String` | HMAC algorithm.
* |===
*
*/
fun signJWT(content: String, key: String, alg: String) : String =
    Common::base64URL(HMACBinary(key as Binary, content as Binary, alg))

/**
* Generate JWT with header, payload, and signature by specific algorithm.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `header` | `Object` | JWT header.
* | `payload` | `Object` | JWT payload.
* | `signingKey` | `String` | Signing key.
* | `algorithm` | `String` | HMAC algorithm.
* |===
*
* === Example
*
* This example shows how `JWT` behaves with the sample input.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* %dw 2.0
* import jwt::HMAC
* output application/json
* ---
* HMAC::JWT({
*             "header": "value"
*           },
*           {
*             "firstName": "Michael",
*             "lastName": "Jones"
*           }, "secret", "HmacSHA384")
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* "eyJhbGCI6IkpXVCJ9.eyJ4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCz"
* ----
*
*/
fun JWT(header: Object, payload: Object, signingKey: String, algorithm: String) : String = do {
    var jwt = Common::JWT({
        (header - "alg" - "typ"),
        alg: alg(algorithm),
        typ: "JWT"
    }, payload)
    ---
    "$(jwt).$(signJWT(jwt, signingKey, algorithm))"
}

/**
* Generate JWT with a header, payload, and key signed with HMAC-SHA256.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `header` | `Object` | JWT header.
* | `payload` | `Object` | JWT paylaod.
* | `signingKey` | `String` | Signing key.
* |===
*
* === Example
*
* This example shows how `JWT` behaves with the sample input.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* import jwt::HMAC
* output application/json
* ---
* HMAC::JWT({
*             "header": "value"
*           },
*           {
*             "firstName": "Michael",
*             "lastName": "Jones"
*           }, "secret")
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* "eyJhbGCI6IkpXVCJ9.eyJ4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCz"
* ----
*
*/
fun JWT(header: Object, payload: Object, signingKey: String) : String = do {
    JWT(header, payload, signingKey, 'HmacSHA256')
}

/**
* Generate JWT with a payload, automatically generated header, and key signed with HMAC-SHA256.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `payload` | `Object` | JWT payload.
* | `signingKey` | `String` | Signing key.
* |===
*
* === Example
*
* This example shows how `JWT` behaves with the sample input.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* import jwt::HMAC
* output application/json
* ---
* HMAC::JWT({
*             "firstName": "Michael",
*             "lastName": "Jones"
*           }, "secret")
*
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* "eyJhbGCI6IkpXVCJ9.eyJ4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCz"
* ----
*
*/
fun JWT(payload: Object, signingKey: String) : String =
    JWT( {},payload, signingKey, 'HmacSHA256')
