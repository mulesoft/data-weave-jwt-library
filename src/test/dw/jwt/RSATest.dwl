%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from jwt::RSA

var key = "-----BEGIN RSA PRIVATE KEY-----\nMIIEogIBAAKCAQEAnzyis1ZjfNB0bBgKFMSvvkTtwlvBsaJq7S5wA+kzeVOVpVWw\nkWdVha4s38XM/pa/yr47av7+z3VTmvDRyAHcaT92whREFpLv9cj5lTeJSibyr/Mr\nm/YtjCZVWgaOYIhwrXwKLqPr/11inWsAkfIytvHWTxZYEcXLgAXFuUuaS3uF9gEi\nNQwzGTU1v0FqkqTBr4B8nW3HCN47XUu0t8Y0e+lf4s4OxQawWD79J9/5d3Ry0vbV\n3Am1FtGJiJvOwRsIfVChDpYStTcHTCMqtvWbV6L11BWkpzGXSW4Hv43qa+GSYOD2\nQU68Mb59oSk2OB+BtOLpJofmbGEGgvmwyCI9MwIDAQABAoIBACiARq2wkltjtcjs\nkFvZ7w1JAORHbEufEO1Eu27zOIlqbgyAcAl7q+/1bip4Z/x1IVES84/yTaM8p0go\namMhvgry/mS8vNi1BN2SAZEnb/7xSxbflb70bX9RHLJqKnp5GZe2jexw+wyXlwaM\n+bclUCrh9e1ltH7IvUrRrQnFJfh+is1fRon9Co9Li0GwoN0x0byrrngU8Ak3Y6D9\nD8GjQA4Elm94ST3izJv8iCOLSDBmzsPsXfcCUZfmTfZ5DbUDMbMxRnSo3nQeoKGC\n0Lj9FkWcfmLcpGlSXTO+Ww1L7EGq+PT3NtRae1FZPwjddQ1/4V905kyQFLamAA5Y\nlSpE2wkCgYEAy1OPLQcZt4NQnQzPz2SBJqQN2P5u3vXl+zNVKP8w4eBv0vWuJJF+\nhkGNnSxXQrTkvDOIUddSKOzHHgSg4nY6K02ecyT0PPm/UZvtRpWrnBjcEVtHEJNp\nbU9pLD5iZ0J9sbzPU/LxPmuAP2Bs8JmTn6aFRspFrP7W0s1Nmk2jsm0CgYEAyH0X\n+jpoqxj4efZfkUrg5GbSEhf+dZglf0tTOA5bVg8IYwtmNk/pniLG/zI7c+GlTc9B\nBwfMr59EzBq/eFMI7+LgXaVUsM/sS4Ry+yeK6SJx/otIMWtDfqxsLD8CPMCRvecC\n2Pip4uSgrl0MOebl9XKp57GoaUWRWRHqwV4Y6h8CgYAZhI4mh4qZtnhKjY4TKDjx\nQYufXSdLAi9v3FxmvchDwOgn4L+PRVdMwDNms2bsL0m5uPn104EzM6w1vzz1zwKz\n5pTpPI0OjgWN13Tq8+PKvm/4Ga2MjgOgPWQkslulO/oMcXbPwWC3hcRdr9tcQtn9\nImf9n2spL/6EDFId+Hp/7QKBgAqlWdiXsWckdE1Fn91/NGHsc8syKvjjk1onDcw0\nNvVi5vcba9oGdElJX3e9mxqUKMrw7msJJv1MX8LWyMQC5L6YNYHDfbPF1q5L4i8j\n8mRex97UVokJQRRA452V2vCO6S5ETgpnad36de3MUxHgCOX3qL382Qx9/THVmbma\n3YfRAoGAUxL/Eu5yvMK8SAt/dJK6FedngcM3JEFNplmtLYVLWhkIlNRGDwkg3I5K\ny18Ae9n7dHVueyslrb6weq7dTkYDi3iOYRW8HRkIQh06wEdbxt0shTzAJvvCQfrB\njg/3747WSsf/zBTcHihTRBdAv6OmdhV4/dD5YBfLAkLrd+mX7iE=\n-----END RSA PRIVATE KEY-----"
var key2 = "-----BEGIN PRIVATE KEY-----\nMIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAqPfgaTEWEP3S9w0t\ngsicURfo+nLW09/0KfOPinhYZ4ouzU+3xC4pSlEp8Ut9FgL0AgqNslNaK34Kq+NZ\njO9DAQIDAQABAkAgkuLEHLaqkWhLgNKagSajeobLS3rPT0Agm0f7k55FXVt743hw\nNgkp98bMNrzy9AQ1mJGbQZGrpr4c8ZAx3aRNAiEAoxK/MgGeeLui385KJ7ZOYktj\nhLBNAB69fKwTZFsUNh0CIQEJQRpFCcydunv2bENcN/oBTRw39E8GNv2pIcNxZkcb\nNQIgbYSzn3Py6AasNj6nEtCfB+i1p3F35TK/87DlPSrmAgkCIQDJLhFoj1gbwRbH\n/bDRPrtlRUDDx44wHoEhSDRdy77eiQIgE6z/k6I+ChN1LLttwX0galITxmAYrOBh\nBVl433tgTTQ=\n-----END PRIVATE KEY-----"
---
"Test RSA" describedBy [
    "Generate JWT" describedBy [
        "It should generate JWT with payload and key [PKCS1]" in do {
            JWT({"firstName": "Michael", "lastName": "Jones"}, key) 
            must equalTo('eyJhbGciOiAiUlMyNTYiLCJ0eXAiOiAiSldUIn0.eyJmaXJzdE5hbWUiOiAiTWljaGFlbCIsImxhc3ROYW1lIjogIkpvbmVzIn0.kvY0JslrAH8206OZ40K2jrNEiTGk3M_w7paK50sAnA9PS89unKNAkSoC-OGmH8LF4MZv-0JNn_LNh6oAm_LQeYRo96g032j2fVtiLW-VhOfTrqdM4Cc5w0ioH7VDXt6Oktt0VCEqayZpjZ2Aw6PRPtBl9M3jlTi3_fFPgF7MQOQ7SSdxfJFXT18LEuacrTlvhf8h1dIluXVZ_ajMjoCQiSxLTPbSyObqpVpRpyxy8SgU8Gviu1qGTrtcs8DSBlT10h3qg455mA42mXggoxe59daJNaAm4sDPsv-D8_vaiIX5sjHoPdaNwljGtoh3GGlGvPkjz518PhN8glZP3QAXXA')
        },
        "It should generate JWT with header, payload, key and algorithm [PKCS1]" in do {
            JWT({"header": "value"}, {"firstName": "Michael", "lastName": "Jones"}, key, 'Sha384withRSA') 
            must equalTo('eyJoZWFkZXIiOiAidmFsdWUiLCJhbGciOiAiUlMzODQiLCJ0eXAiOiAiSldUIn0.eyJmaXJzdE5hbWUiOiAiTWljaGFlbCIsImxhc3ROYW1lIjogIkpvbmVzIn0.a8juoDsbTN-qtsRLKUfCAZQXSrdjgtZDW2qfGPpkfwZBTCrlDFtUtrW3R9HrY94FAFpAvGTed-GOznnAQoMBvEifXiVyKcE3CLh5eJ7tjuc-NAZB2ODeJuWinVEneulgfXNuKKm-HL00SdJ7hV-vcieeHDcv7g5e0vUuHYpQWWo_GuoF0ibYimOUGTWwxQz8xMvpxJCzuPXSvYqPiqzSKtCl6DQH12A0O_j-CO7TUirkxEQxEnb8iA34ja1I5goNz3CNPJ8eweCFSh7Cvl0MqBjfkkgasD0zuPtWAKNV6Vi-0cCncu2Ow_m7I_goaquTD86SFuQfeMmiYLDbiVftow')
        },
        "It should generate JWT with payload and key [PKCS8]" in do {
            JWT({"firstName": "Michael", "lastName": "Jones"}, key2)
            must equalTo('eyJhbGciOiAiUlMyNTYiLCJ0eXAiOiAiSldUIn0.eyJmaXJzdE5hbWUiOiAiTWljaGFlbCIsImxhc3ROYW1lIjogIkpvbmVzIn0.hpguwFknfGlQ3xV1dVcICykcKjeUXfsNV65FUdJqxDC0lSMV42DH0vOuycpD3NWDg1dvdRb3f0kyk-Zze44RoQ')
        }
    ],
]
