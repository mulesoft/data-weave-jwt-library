%dw 2.0
import toBase64 from dw::core::Binaries
import * from dw::core::Strings


fun binaryJson(obj: Object) =
    write(obj, 'application/json', {indent: false}) as Binary

fun base64URL(str: Binary) =
    toBase64(str) replace "+" with pluralize("-") replace "/" with "_" replace "=" with ""

fun base64Obj(obj: Object) = base64URL(binaryJson(obj))

fun JWT(header: Object, payload: Object) = 
    "$(base64Obj(header)).$(base64Obj(payload))"

fun JWT(payload: Object) =
    JWT({typ: 'JWT'}, payload)
