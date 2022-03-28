# DataWeave JWT Library

[![Development Branch](https://github.com/mulesoft/data-weave-jwt-library/actions/workflows/master_workflow.yml/badge.svg?branch=master)](https://github.com/mulesoft/data-weave-jwt-library/actions/workflows/master_workflow.yml)

This library provides functionality to create signed JSON Web Tokens directly on DataWeave with RSA and HMAC signatures.

## Overview

This is a simple example using an HMAC signature:

```dataweave
%dw 2.0
import jwt::HMAC
output application/json
---
HMAC::JWT({
        "firstName": "Michael", 
        "lastName": "Jones"
    }, "d4t4w34v3!")
```

And this is a more complex example, where the key is an input to the transformation:

```dataweave
%dw 2.0
import * from jwt::RSA

output application/json
input key application/json
---
{
	token: JWT(
		{
			iss: "some@email.com",
			aud: 'https://oauth2.googleapis.com/token',
			scope: 'https://www.googleapis.com/auth/drive.readonly',
			iat: now() as Number { unit: 'seconds' },
			exp: (now() + |PT3600S|) as Number { unit: 'seconds' }
		},
		key
	),
	expiration: now() + |PT3550S|
}
```

## Contributions Welcome

Contributions to this project can be made through Pull Requests and Issues on the
[GitHub Repository](https://github.com/mulesoft/data-weave-jwt-library).

Before creating a pull request review the following:

* [LICENSE](https://github.com/mulesoft/data-weave-jwt-library/blob/master/LICENSE.txt)
* [SECURITY](https://github.com/mulesoft/data-weave-jwt-library/blob/master/SECURITY.md)
* [CODE_OF_CONDUCT](https://github.com/mulesoft/data-weave-jwt-library/blob/master/CODE_OF_CONDUCT.md)

When you submit your pull request, you are asked to sign a contributor license agreement (CLA) if we don't have one on file for you.