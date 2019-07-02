#! /usr/bin/jq -srf
# json2xpath.jq
#
# json2xpath.jq <data.json> | sort -u > <data.xpath>
#
# reduce a json structure to an aproximation of xml xpaths
#  - without sort to know what order to expect
#  - without unique to know how many of each path

[
    paths |
    map(select(type!="number"))
]|
# sort |    # uncomment to loose order
# unique |  # uncomment to loose counts
 .[] |
 select(length>0) |
 "./" + join("/")

# '[paths]|map(select(type!="number"))]|sort|unique|.[]|select(length>0)|"./"+join("/")'
