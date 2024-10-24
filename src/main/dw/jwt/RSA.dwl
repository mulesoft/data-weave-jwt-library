/**
* This module provides functionality to create signed JSON Web Tokens using RSA signatures.
*
* The supported RSA algorithms are:
*  - RS256
*  - RS384
*  - RS512
*
* RSA private keys must be in `PKCS#1` or `PKCS#8` format.
*/
%dw 2.0
import java!org::mule::weave::v2::jwt::RSAHelper
import jwt::Common
import fail from dw::Runtime

/**
* Supported RSA algorithms.
*/
var algMapping = {
    "Sha256withRSA": "RS256",
    "Sha384withRSA": "RS384",
    "Sha512withRSA": "RS512"
}

/**
* Helper function to validate the algorithm provided for signing.
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
* | `jwt` | `String` | Header and payload parts of the JWT.
* | `privateKey` | `String` | Signing key.
* | `algorithm` | `String` | Algorithm provided for signing.
* |===
*
*/
fun signJWT(jwt: String, privateKey: String, algorithm: String) : String =
    RSAHelper::signString(jwt, privateKey, algorithm)


/**
* Helper function to sign the JWT with keystore.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `jwt` | `String` | Header and payload parts of the JWT.
* | `signingKey` | `String` | Signing key.
* | `keystorePath` | `String` | Key Store path
* | `keystoreType` | `String` | Supported values: PKCS12 or JKS
* | `keystorePassword` | `String` | Keystore password
* | `keyAlias` | `String` | Key alias in keystore
* | `algorithm` | `String` | RSA algorithm.
* |===
*
*/
fun signJWTWithKeyStore(jwt: String, keystorePath: String, keystoreType: String, keystorePassword: String, keyAlias: String, algorithm: String) : String =
    RSAHelper::signStringWithKeyStore(jwt, keystorePath, keystoreType, keystorePassword, keyAlias, algorithm)

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
* import * from jwt::RSA
*
* output application/json
* input key application/json
* ---
* {
* 	token: JWT(
*       {
*           header: "value"
*       },
* 		{
* 			iss: "some@email.com",
* 			aud: 'https://oauth2.googleapis.com/token',
* 			scope: 'https://www.googleapis.com/auth/drive.readonly',
* 			iat: now() as Number { unit: 'seconds' },
* 			exp: (now() + |PT3600S|) as Number { unit: 'seconds' }
* 		},
* 		key,
*       'Sha384withRSA'
* 	),
* 	expiration: now() + |PT3550S|
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
* | `payload` | `Object` | JWT payload.
* | `signingKey` | `String` | Signing key.
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
* import * from jwt::RSA
*
* output application/json
* input key application/json
* ---
* {
* 	token: JWT(
* 		{
* 			iss: "some@email.com",
* 			aud: 'https://oauth2.googleapis.com/token',
* 			scope: 'https://www.googleapis.com/auth/drive.readonly',
* 			iat: now() as Number { unit: 'seconds' },
* 			exp: (now() + |PT3600S|) as Number { unit: 'seconds' }
* 		},
* 		key
* 	),
* 	expiration: now() + |PT3550S|
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
* | `keystorePath` | `String` | Key Store path
* | `keystoreType` | `String` | Supported values: PKCS12 or JKS
* | `keystorePassword` | `String` | Keystore password
* | `keyAlias` | `String` | Key alias in keystore
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
*%dw 2.0
*import * from jwt::RSA
*
*output application/json
*---
*{
*	token: JWTWithKeyStore(
*		{},
*		{
*			"iss": "foo,bar",
*			"sub": "bar.foo",
*			"aud": "https://foo.bar",
*			"iat": 1729766838,
*			"exp": 1729770438
*  		},
*		'foo.p12',
*		'PKCS12',
*		'foo',
*		'foo.bar',
*		'Sha256withRSA'
*	),
*	expiration: now() + |PT3550S|
*}
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
fun JWTWithKeyStore(header: Object, payload: Object, keystorePath: String, keystoreType: String, keystorePassword: String, keyAlias: String, algorithm: String) : String = do {
    var jwt = Common::JWT(
    { (header - "alg" - "typ"), alg: alg(algorithm), typ: 'JWT' },
    payload)
    ---
    "$(jwt).$(signJWTWithKeyStore(jwt, keystorePath, keystoreType, keystorePassword, keyAlias,  algorithm))"
}
