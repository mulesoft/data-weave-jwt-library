%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from jwt::HMAC
---
"Test HMAC" describedBy [
    "Generate JWT" describedBy [
        "It should generate JWT with payload and key" in do {
            JWT({"firstName": "Michael", "lastName": "Jones"}, "secret") 
            must equalTo('eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0.eyJmaXJzdE5hbWUiOiAiTWljaGFlbCIsImxhc3ROYW1lIjogIkpvbmVzIn0.LkcwPNk0TECrZxB5NUZLHliQTijX5wPupjaK1svpuY0')
        },
        "It should generate JWT with header, payload and key" in do {
            JWT({"header": "value"},
                {"firstName": "Michael", "lastName": "Jones"}, "secret") 
            must equalTo('eyJoZWFkZXIiOiAidmFsdWUiLCJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0.eyJmaXJzdE5hbWUiOiAiTWljaGFlbCIsImxhc3ROYW1lIjogIkpvbmVzIn0.2myUmqRS3R4jMeeq6K2nwqwj3KIc2c_7hZSKIs2kMxw')
        },
        "It should generate JWT with header, payload, key and algorithm" in do {
            JWT({"header": "value"},
                {"firstName": "Michael", "lastName": "Jones"},
                "secret", "HmacSHA384") 
            must equalTo('eyJoZWFkZXIiOiAidmFsdWUiLCJhbGciOiAiSFMzODQiLCJ0eXAiOiAiSldUIn0.eyJmaXJzdE5hbWUiOiAiTWljaGFlbCIsImxhc3ROYW1lIjogIkpvbmVzIn0.9phLXWyZz53QYO6bmYw9mXwEmdD55bnzIjGwYKYLXhFoTBpjiYfMgKh2C-s97F65w')
        },
    ],
]
