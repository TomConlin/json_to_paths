#! /usr/bin/jq -srf
# json2jqpath.jq
#
# json2jqpath.jq <data.json> > <data.jqpath>
#
# reduce a json structure to a set of paths addressable by `jq`
# 

[
    paths | 
    .[1:] |
    map(select(type == "string") //  "[]") |
    "." + join("|.") |
    tostring 
] |
unique |
sort |
.[]

# '[paths|.[1:]|map(select(type=="string")//"[]")|"."+join("|.")|tostring]|unique|sort|.[]'

