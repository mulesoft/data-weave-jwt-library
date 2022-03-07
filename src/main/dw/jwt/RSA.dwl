/**
* This module provides functionality to create signed JSON Web Tokens using RSA signatures.
*/
%dw 2.0
import java!RSAHelper
import jwt::Common
import fail from dw::Runtime

var algMapping = {
    "Sha256withRSA": "RS256",
    "Sha384withRSA": "RS384",
    "Sha512withRSA": "RS512"
}

/**
* Helper function to validate the algorithm provided for signing.
*/
fun alg(algorithm: String) : String | Null =
    algMapping[algorithm] default fail('Invalid algorithm provided for signing')

/**
* Helper function to sanitize the key.
*/
fun cleanKey(key: String) : String =
    log(key replace "\n" with "" replace /(-+)(BEGIN|END)(\sRSA)? (PRIVATE|PUBLIC) KEY(-+)/ with "" replace " " with "")

/**
* Helper function to sign the JWT.
*/
fun signJWT(jwt: String, privateKey: String, algorithm: String) : String =
    RSAHelper::signString(jwt, privateKey, algorithm)

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
* | `algorithm` | `String` | RSA algorithm.
* |===
*
* === Example
*
* This example shows how the `JWT` behaves with the sample input.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import jwt::RSA
* ---
* {
*     token: RSA::JWT(
*         {
*             header: "value"
*         },
*         {
*             iss: p('google.clientEmail'),
*             aud: 'https://oauth2.googleapis.com/token',
*             scope: 'https://www.googleapis.com/auth/drive.readonly',
*             iat: now() as Number { unit: 'seconds' },
*             exp: (now() + |PT3600S|) as Number { unit: 'seconds' }
*         }, p('google.privateKey'), 'Sha384withRSA'),
*     expiration: now() + |PT3550S|
* }
*
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* {
*    token: "eyJhbGCI6IkpXVCJ9.eyJ4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCz",
*    "expiration": "2031-11-18T15:11:31.060175Z"
* }
* ----
*
*/
fun JWT(header: Object, payload: Object, signingKey: String, algorithm: String) : String = do {
    var jwt = Common::JWT(
    { (header - "alg" - "typ"), alg: alg(algorithm), typ: 'JWT' },
    payload)
    ---
    "$(jwt).$(signJWT(jwt, signingKey, algorithm))"
}

/**
* Generate JWT with a payload, automatically generated header, and key signed with RS256.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `payload` | Object | JWT payload.
* | `signingKey` | String | Signing key.
* |===
*
* === Example
*
* This example shows how the `JWT` behaves with the sample input.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import jwt::RSA
* ---
* {
*     token: RSA::JWT(
*         {
*             iss: p('google.clientEmail'),
*             aud: 'https://oauth2.googleapis.com/token',
*             scope: 'https://www.googleapis.com/auth/drive.readonly',
*             iat: now() as Number { unit: 'seconds' },
*             exp: (now() + |PT3600S|) as Number { unit: 'seconds' }
*         },
*         p('google.privateKey')
*     ),
*     expiration: now() + |PT3550S|
* }
*
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* {
*    token: "eyJhbGCI6IkpXVCJ9.eyJ4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCz",
*    "expiration": "2031-11-18T15:11:31.060175Z"
* }
* ----
*
*/
fun JWT(payload: Object, signingKey: String) : String =
    JWT({}, payload, signingKey, "Sha256withRSA")
