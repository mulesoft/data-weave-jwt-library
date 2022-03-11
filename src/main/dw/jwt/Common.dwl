/**
* This module provides helper functions to create signed JSON Web Tokens.
*/
%dw 2.0
import toBase64 from dw::core::Binaries


/**
* Helper function that converts a JSON object to binary format.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `obj` | `Object` | JSON object to convert to binary.
* |===
*
*/
fun binaryJson(obj: Object) =
    write(obj, 'application/json', {indent: false}) as Binary

/**
* Helper function that converts a binary to base64 format with URL-safe alphabet (RFC-4648#5).
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `str` | `Binary` | Binary to encode in base64 format.
* |===
*
*/
fun base64URL(str: Binary) =
    toBase64(str) replace "+" with "-" replace "/" with "_" replace "=" with ""

/**
* Helper function that converts a JSON object to base64 format.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `obj` | `Object` | JSON object to convert to base64 format.
* |===
*
*/
fun base64Obj(obj: Object) = base64URL(binaryJson(obj))

/**
* Helper function to generate the header and payload JWT parts of the token.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `header` | `Object` | Header to encode as part of the JWT.
* | `payload` | `Object` | Payload to encode as part of the JWT.
* |===
*
*/
fun JWT(header: Object, payload: Object) = 
    "$(base64Obj(header)).$(base64Obj(payload))"

/**
* Helper function to generate the header and payload JWT parts of the token using a default header.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `payload` | `Object` | Payload to encode as part of the JWT.
* |===
*
*/
fun JWT(payload: Object) =
    JWT({typ: 'JWT'}, payload)
