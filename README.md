
### JSON to XML XPATH(-ish)

#### Purpose
To get insight into the structure of arbitrary JSON files from the command line
similar the way I pre process XML files.

### Requirements

 - `jq` installed see https://github.com/stedolan/jq/
(Most likely installs with your package manager.)

 - the one liner jq script this ropo is for

#### Usage

Snagging a random (to me) test JSON file from a neat looking
[awk json parser project](https://github.com/step-/JSON.awk)

```
curl -sL https://github.com/step-/JSON.awk/raw/master/test-cases/20170131-issue-007-test.json > testdata.json
```

#### Result
```
./json2xpath.jq testdata.json| sort -u > testdata.xpath
cat testdata.xpath
./response
./response/count
./response/data
./response/data/person
./response/data/person/address
./response/data/person/age
./response/data/person/balance
./response/data/person/company
./response/data/person/coords
./response/data/person/coords/lat
./response/data/person/coords/long
./response/data/person/email
./response/data/person/gender
./response/dfromata/person/guid
./response/data/person/id
./response/data/person/isActive
./response/data/person/name
./response/data/person/phone
./response/data/person/picture
./response/data/person/registered
./response/data/person/tags
./response/pagecount
```

which is a good starting point for tools such as [xpath2dot.awk](https://github.com/TomConlin/xpath2dot)


```
./json2xpath.jq testdata.json|
    sort -u |
    xpath2dot.awk -v ORIENT="UD" |
    dot -T svg > testdata.svg

```

![testdata.svg](https://github.com/TomConlin/json2xpath/blob/master/testdata.svg)

For deeper exploration with `jq` xpath is not appropriate,
but the syntax is not too far off.

replace the forward-slash with a pipe and a dot

```
sed 's~/~|.~g' testdata.xpath > testdata.jqpath
cat testdata.jqpath
.|.response
.|.response|.count
.|.response|.data
.|.response|.data|.person
.|.response|.data|.person|.address
.|.response|.data|.person|.age
.|.response|.data|.person|.balance
.|.response|.data|.person|.company
.|.response|.data|.person|.coords
.|.response|.data|.person|.coords|.lat
.|.response|.data|.person|.coords|.long
.|.response|.data|.person|.email
.|.response|.data|.person|.gender
.|.response|.data|.person|.guid
.|.response|.data|.person|.id
.|.response|.data|.person|.isActive
.|.response|.data|.person|.name
.|.response|.data|.person|.phone
.|.response|.data|.person|.picture
.|.response|.data|.person|.registered
.|.response|.data|.person|.tags
.|.response|.pagecount

```

Note: making up the format suffix `.jqpath`

Which will __not__ work directly in the general case
as we are not differentiating objects from arrays
which need to be iterated over with `.[]`

`jq` will helpfully tell you where array iterator are missing.

```
jq ".|.response|.data|.person|.name" testdata.json
jq: error (at testdata.json:26227): Cannot index array with string "person"
```
If we can't index an array with "person" it he because its predecessor is an array.

```
jq ".|.response|.data|.[]|.person|.name,.coords" testdata.json | head
"Anastasia Goodwin"
{
  "lat": 71.050828,
  "long": 113.565478
}
"Peters Watson"
{
  "lat": 0.203464,
  "long": -71.896296
}

```

--------

A note on the use of `sort -u` above

The script `json2xpath.jq` has the ability to sort and remove duplicates but they
are commented out.

They are disabled by default to allow more uses
for example:

 - We may be extracting data in some other program & want to know the native order
 - We may be interested in counts of things of various types

If you know these are not your use case you can uncomment them in the script
and eliminate piping the output through  `sort -u`

