# DataWeave JWT Module

This module provides functionality to create signed JSON Web Tokens. The following formats are currently support:

* HS256
* HS384
* HS512

* RS256
* RS384
* RS512

RSA private keys must be in PKCS#1 or PKCS#8 format.

Example RSA usage:

```dataweave
%dw 2.0
output application/java
import jwt::RSA
---
{
	token: RSA::JWT(
		{
			iss: p('google.clientEmail'),
			aud: 'https://oauth2.googleapis.com/token',
			scope: 'https://www.googleapis.com/auth/drive.readonly',
			iat: now() as Number { unit: 'seconds' },
			exp: (now() + |PT3600S|) as Number { unit: 'seconds' }
		},
		p('google.privateKey')
	),
	expiration: now() + |PT3550S|
}
```

Example HMAC usage:

```dataweave
%dw 2.0
import jwt::HMAC
output application/json
---
HMAC::JWT({
            "firstName": "Michael",
            "lastName": "Jones"
          }, "Mulesoft123!")
```

# jwt::HMAC Functions

## Valid Algorithms

- HS256
- HS384
- HS512

_*NOTE: Header `typ` and `alg` keys will be added/overriden automatically*_

### JWT(header: Object, payload: Object, signingKey: String, algorithm: String): String

Returns a signed JSON web token with the specified `header` and `payload` (body), signed using `signingKey` and algorithm specified by `algorithm`.
__________________________________________

### JWT(header: Object, payload: Object, signingKey: String): String

Returns a signed JSON web token with the specified `header` and `payload` (body), signed using `signingKey` via the HMAC-SHA256 (HS256) algorithm.
__________________________________________

### JWT(payload: Object, signingKey: String): String

Returns a signed JSON web token with the specified `payload` (body), signed using `signingKey` via the HMAC-SHA256 (HS256) algorithm. Header is defaulted as `{ "alg": "HS256", "typ": "JWT" }`
__________________________________________

# jwt::RSA Functions

## Valid Algorithms

- RS256
- RS384
- RS512

_*NOTE: Header `typ` and `alg` keys will be added/overriden automatically*_


### JWT(header: Object, payload: Object, privateKey: String, algorithm: String): String

Returns a signed JSON web token with the specified `header` and `payload` (body), signed using PKCS#1 or PKCS#8 `privateKey` and algorithm specified by `algorithm`.
__________________________________________

### JWT(payload: Object, privateKey: String): String

Returns a signed JSON web token with the specified `header` and `payload` (body), signed using PKCS#1 or PKCS#8 `privateKey` and algorithm HMAC-SHA256.
