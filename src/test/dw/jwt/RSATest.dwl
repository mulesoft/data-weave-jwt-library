%dw 2.0
import try, fail from dw::Runtime
import * from dw::test::Tests
import * from dw::test::Asserts

import * from jwt::RSA

var key = "-----BEGIN RSA PRIVATE KEY-----\nMIIEogIBAAKCAQEAnzyis1ZjfNB0bBgKFMSvvkTtwlvBsaJq7S5wA+kzeVOVpVWw\nkWdVha4s38XM/pa/yr47av7+z3VTmvDRyAHcaT92whREFpLv9cj5lTeJSibyr/Mr\nm/YtjCZVWgaOYIhwrXwKLqPr/11inWsAkfIytvHWTxZYEcXLgAXFuUuaS3uF9gEi\nNQwzGTU1v0FqkqTBr4B8nW3HCN47XUu0t8Y0e+lf4s4OxQawWD79J9/5d3Ry0vbV\n3Am1FtGJiJvOwRsIfVChDpYStTcHTCMqtvWbV6L11BWkpzGXSW4Hv43qa+GSYOD2\nQU68Mb59oSk2OB+BtOLpJofmbGEGgvmwyCI9MwIDAQABAoIBACiARq2wkltjtcjs\nkFvZ7w1JAORHbEufEO1Eu27zOIlqbgyAcAl7q+/1bip4Z/x1IVES84/yTaM8p0go\namMhvgry/mS8vNi1BN2SAZEnb/7xSxbflb70bX9RHLJqKnp5GZe2jexw+wyXlwaM\n+bclUCrh9e1ltH7IvUrRrQnFJfh+is1fRon9Co9Li0GwoN0x0byrrngU8Ak3Y6D9\nD8GjQA4Elm94ST3izJv8iCOLSDBmzsPsXfcCUZfmTfZ5DbUDMbMxRnSo3nQeoKGC\n0Lj9FkWcfmLcpGlSXTO+Ww1L7EGq+PT3NtRae1FZPwjddQ1/4V905kyQFLamAA5Y\nlSpE2wkCgYEAy1OPLQcZt4NQnQzPz2SBJqQN2P5u3vXl+zNVKP8w4eBv0vWuJJF+\nhkGNnSxXQrTkvDOIUddSKOzHHgSg4nY6K02ecyT0PPm/UZvtRpWrnBjcEVtHEJNp\nbU9pLD5iZ0J9sbzPU/LxPmuAP2Bs8JmTn6aFRspFrP7W0s1Nmk2jsm0CgYEAyH0X\n+jpoqxj4efZfkUrg5GbSEhf+dZglf0tTOA5bVg8IYwtmNk/pniLG/zI7c+GlTc9B\nBwfMr59EzBq/eFMI7+LgXaVUsM/sS4Ry+yeK6SJx/otIMWtDfqxsLD8CPMCRvecC\n2Pip4uSgrl0MOebl9XKp57GoaUWRWRHqwV4Y6h8CgYAZhI4mh4qZtnhKjY4TKDjx\nQYufXSdLAi9v3FxmvchDwOgn4L+PRVdMwDNms2bsL0m5uPn104EzM6w1vzz1zwKz\n5pTpPI0OjgWN13Tq8+PKvm/4Ga2MjgOgPWQkslulO/oMcXbPwWC3hcRdr9tcQtn9\nImf9n2spL/6EDFId+Hp/7QKBgAqlWdiXsWckdE1Fn91/NGHsc8syKvjjk1onDcw0\nNvVi5vcba9oGdElJX3e9mxqUKMrw7msJJv1MX8LWyMQC5L6YNYHDfbPF1q5L4i8j\n8mRex97UVokJQRRA452V2vCO6S5ETgpnad36de3MUxHgCOX3qL382Qx9/THVmbma\n3YfRAoGAUxL/Eu5yvMK8SAt/dJK6FedngcM3JEFNplmtLYVLWhkIlNRGDwkg3I5K\ny18Ae9n7dHVueyslrb6weq7dTkYDi3iOYRW8HRkIQh06wEdbxt0shTzAJvvCQfrB\njg/3747WSsf/zBTcHihTRBdAv6OmdhV4/dD5YBfLAkLrd+mX7iE=\n-----END RSA PRIVATE KEY-----"
var key2= "-----BEGIN PRIVATE KEY-----\nMIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAqPfgaTEWEP3S9w0t\ngsicURfo+nLW09/0KfOPinhYZ4ouzU+3xC4pSlEp8Ut9FgL0AgqNslNaK34Kq+NZ\njO9DAQIDAQABAkAgkuLEHLaqkWhLgNKagSajeobLS3rPT0Agm0f7k55FXVt743hw\nNgkp98bMNrzy9AQ1mJGbQZGrpr4c8ZAx3aRNAiEAoxK/MgGeeLui385KJ7ZOYktj\nhLBNAB69fKwTZFsUNh0CIQEJQRpFCcydunv2bENcN/oBTRw39E8GNv2pIcNxZkcb\nNQIgbYSzn3Py6AasNj6nEtCfB+i1p3F35TK/87DlPSrmAgkCIQDJLhFoj1gbwRbH\n/bDRPrtlRUDDx44wHoEhSDRdy77eiQIgE6z/k6I+ChN1LLttwX0galITxmAYrOBh\nBVl433tgTTQ=\n-----END PRIVATE KEY-----"
var keyRSAInside= "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDPma9jHfdOxPF3\nMyc1s/UXlnYj3nfT6J583sGOry/kvFFuo7XQGe09ktkJBy/HAw03VaT3rwlmxxu2\nPrJThewnQgx3Zjo9IWOE2+hxPn9skg753f9TkvYegMEokO+QQT6in2J4I1WoAmdU\n7RSANas8lJQXTjMsm4sZ8lWCtBAUnHbbF/q7Ncn8C2fR3FskPRZYKvjAZ8dawA4m\nsvScnw0AebTncHjG/3EvLdp6PWkd/YEcVBdmZjrem3kGT0d3XF12R3ZWR5Gnsf3m\nIQnGuAPPXCNiegrsR9jvUVUN/AQSy5bLu2WPSNIddKdLPupUjWGm4fd4O+cJnZZE\n9I/ek6A5AgMBAAECggEABY6ioETxatK2Iq+5hqQo6mxlAIl4VwbXaeujQ3OIaldp\ngqGv60CBFkXeY3HQI0P/UDzjAUer48FutM6G2C+HO8x2faJnQAhVxqewWDUJFNnw\nEVuSSyVtoIa9JPMu8S3zREfUoKH+1/7Vz0iCuk/gI+tXmiwbYz/4AEYkEy9IwunE\n9oMYws+zc9sNj14v3HKEDEyTD2dUc/ZI+UPdXiO6LliYi4KkGRgNH601+0KKB9rY\nd5hXb7K0+hamS07/lH4WfD3Dssj74orbGIzk7uiQ9ZKtMvKZCH63m53YKQGrnN7L\nFGREe3Ei1J8ySEZA3cwELfV1Gb/UWyzPMn8+pKNAgQKBgQDwD/wsqtgKgVDKRT9N\nA7o9ddSShJhpuJLVWVBzySUUHvLI+d2AuU19YWdx/obWTtGU0ckTgR8Mc26PlN5/\nZgrYwwN25IfY7jQcjW9SRi4fGPqXm15KSSIDO+x7ipSo225tRXqNRFqUD+x32qjo\nIkIcMF9EYrzQWvYAE7yxsJLxKQKBgQDdYfxXu5C7/kdroV8mWuxTrqNYqnYIRhaE\nBNwQK/1zsKBUDcvW3rv9R6ubok6iBnJCnTZ4xneUD339cNzhC97TNUvi9SCQ9NLP\n+IgOyy3VnP6kfmtIuPnAJwvFZcHWGlztIiWsN6CFsDvVCzx83OWQw3c2JHz7S+No\n9apNAInIkQKBgHoxuMvHvqZCQqxi6SC7h/4mzygxZB9UOzFr//6f4UbHpg9U2EHg\nkKgEf5JP27SUdCvLSQ2riPFehGWDgmnYuCazxTysgNWUEmSCParkXC+qGEw5Yppv\ndWeuBeawmJEG+MOYPRRROcXqARTU8WsPnRUaLjPyCmgIFPXfFgpgdbtZAoGAW+ec\nwbM9P74tWjJQ9PRUHd1nNJz3iTHHkSEPVqtcedW+iYZ8tAQdmOVTCbZU3JC+iIcJ\noRQLem0ACeH74HV0GMyMZ3kJ/wOULQBpQ3L34TFeyV0uHq+kBzBug5Fd6gthvpQp\nfZhOTJHAFQ6oGtH9f56V8+Ur+YskqmMqQvNRP/ECgYBGIEwCFXucXZsKEUap1rbb\nEiwJNXRyV/7hwAs/2/4F9+Jvvaby6qlGNf/YdxT5FDpj17tanUJqw1Xu2Icv39T1\nr0GRLBhD2SygjQ3OLM4FxL2YIR2yGp44DNQcwtStDuZkoZ4X+dkqsWwh2gLOATJr\nEgEKL7aN3KxAqm7jEYgTGg==\n-----END PRIVATE KEY-----\n"
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
        },
        "It should generate JWT with payload and key [PKCS8] when key contains 'RSA' string value" in do {
          JWT({"firstName": "Michael", "lastName": "Jones"}, keyRSAInside)
          must equalTo('eyJhbGciOiAiUlMyNTYiLCJ0eXAiOiAiSldUIn0.eyJmaXJzdE5hbWUiOiAiTWljaGFlbCIsImxhc3ROYW1lIjogIkpvbmVzIn0.A57lqrxLLyYS3Ze9iBVHbnWbv5rp5OlhgnGqsgg31cQgaHAdcO-lobXcx_c1LoLbUQMcy_OS5HPCh3swTLumyAZedh0kO_Oukvv6tzrp79euP72rMOThe4KwGwIhJ0codrbYkDp7M_bMK9dxQGzTaJQ1W6f2c61ugmLIreS8UI0Z6UO8q1ZDImuYDgFWeFiiTlHQ2KmLB06xOngqCUFPAYqNHRUwirkt8kzkw4AZqNDq2qngibQg-FRFspMufkMcYP6-R4sP2taJ1LLMBXSJQ44DWwbik4urUgxMQPPSFQwvStJ05PCw6JmCmRgIPyNCEAP5moUW87eXYJ5D-h0amA')
        },
        "It should generate JWT with payload and key [PKCS8] when using key in a PKCS12 keystore" in do {
                    JWTWithKeyStore(
                    		{},
                    		{
                                "iss": "foo,bar",
                                "sub": "bar.foo",
                                "aud": "https://foo.bar",
                                "iat": 1729766838,
                                "exp": 1729770438
                            },
                    		'foo.p12',
                    		'PKCS12',
                    		'foo',
                    		'foo.bar',
                    		'Sha256withRSA'
                    	)
                    must equalTo('eyJhbGciOiAiUlMyNTYiLCJ0eXAiOiAiSldUIn0.eyJpc3MiOiAiZm9vLGJhciIsInN1YiI6ICJiYXIuZm9vIiwiYXVkIjogImh0dHBzOi8vZm9vLmJhciIsImlhdCI6IDE3Mjk3NjY4MzgsImV4cCI6IDE3Mjk3NzA0Mzh9.oyD6DLIBKDJJ0GOgd7kdhoHAVoCtgSpgEkMhBiV7x69qwYZ3bvTmm5EIljHnPUMeR9aK_yh_A7-ZRO2kA6w94pGqBXnABrsiBbHC4U-2cIzJkq-WBQcSsY8TQtCiaBdhsD3Lp3Gr6kl0q5_AgMnhNG3i_0p8-mQ4FcsTPwNsbSGV4lGVB5IbfYtpmLenpLTIt0aGplD0LLrpBIF7MlOpK5H4SLuILyRhw5d1NSHVmIUwk1u5x9gY1zq7C52ND_HdFa_EvOKO8sxcVk39h5I0CzNdr8arIy1bnTkR86GAt3vS_62YNOeRtD46WE7d0L7ZtFme-Iw0LGJ9Vl1n5OmkIw')
        },
        "It should generate JWT with payload and key [PKCS8] when using key in a JKS keystore" in do {
                    JWTWithKeyStore(
                            {},
                            {
                                "iss": "foo,bar",
                                "sub": "bar.foo",
                                "aud": "https://foo.bar",
                                "iat": 1729766838,
                                "exp": 1729770438
                            },
                            'foo.jks',
                            'JKS',
                            'foo',
                            'foo.bar',
                            'Sha256withRSA'
                        )
                    must equalTo('eyJhbGciOiAiUlMyNTYiLCJ0eXAiOiAiSldUIn0.eyJpc3MiOiAiZm9vLGJhciIsInN1YiI6ICJiYXIuZm9vIiwiYXVkIjogImh0dHBzOi8vZm9vLmJhciIsImlhdCI6IDE3Mjk3NjY4MzgsImV4cCI6IDE3Mjk3NzA0Mzh9.oyD6DLIBKDJJ0GOgd7kdhoHAVoCtgSpgEkMhBiV7x69qwYZ3bvTmm5EIljHnPUMeR9aK_yh_A7-ZRO2kA6w94pGqBXnABrsiBbHC4U-2cIzJkq-WBQcSsY8TQtCiaBdhsD3Lp3Gr6kl0q5_AgMnhNG3i_0p8-mQ4FcsTPwNsbSGV4lGVB5IbfYtpmLenpLTIt0aGplD0LLrpBIF7MlOpK5H4SLuILyRhw5d1NSHVmIUwk1u5x9gY1zq7C52ND_HdFa_EvOKO8sxcVk39h5I0CzNdr8arIy1bnTkR86GAt3vS_62YNOeRtD46WE7d0L7ZtFme-Iw0LGJ9Vl1n5OmkIw')
        },
        "It should return an IllegalArgumentException with invalid keystore path" in do {
                            try(() -> JWTWithKeyStore(
                                                                  {},
                                                                  {
                                                                      "iss": "foo,bar",
                                                                      "sub": "bar.foo",
                                                                      "aud": "https://foo.bar",
                                                                      "iat": 1729766838,
                                                                      "exp": 1729770438
                                                                  },
                                                                  'fob.jks',
                                                                  'JKS',
                                                                  'foo',
                                                                  'foo.bar',
                                                                  'Sha256withRSA'
                                                              )) must  [
                                                               $.success is false,
                                                               $.error.message contains  'Keystore file not found'
                                                              ]
        },
        "It should return an IllegalArgumentException with invalid key alias" in do {
                                    try(() -> JWTWithKeyStore(
                                                                          {},
                                                                          {
                                                                              "iss": "foo,bar",
                                                                              "sub": "bar.foo",
                                                                              "aud": "https://foo.bar",
                                                                              "iat": 1729766838,
                                                                              "exp": 1729770438
                                                                          },
                                                                          'foo.jks',
                                                                          'JKS',
                                                                          'foo',
                                                                          'bar.foo',
                                                                          'Sha256withRSA'
                                                                      )) must  [
                                                                        $.success is false,
                                                                        $.error.message contains  'Alias not found'
                                                                      ]


        },
    ],
]
