
### JSON to `jq` paths  or XML xpath

#### Purpose
To get insight into the structure of arbitrary JSON files from the command line.
Provides building blocks for further processing both with 'jq' as well as other tools
intended to be used with XML xpath.



### Requirements

 - `jq` installed see https://github.com/stedolan/jq/
(Most likely installs with your package manager.)

 - the one liner jq scripts this ropo is for

#### Usage

Snagging a random (to me) test JSON file from a neat looking
[awk json parser project](https://github.com/step-/JSON.awk)

```
curl -sL https://github.com/step-/JSON.awk/raw/master/test-cases/20170131-issue-007-test.json > testdata.json
```
### Result from generating `jq` paths
```
 ./json2jqpath.jq testdata.json > testdata.jqpath
```
Note: making up the format suffix `.jqpath`

```
cat testdata.jqpath
.
.response
.response|.count
.response|.data
.response|.data|.[]
.response|.data|.[]|.person
.response|.data|.[]|.person|.address
.response|.data|.[]|.person|.age
.response|.data|.[]|.person|.balance
.response|.data|.[]|.person|.company
.response|.data|.[]|.person|.coords
.response|.data|.[]|.person|.coords|.lat
.response|.data|.[]|.person|.coords|.long
.response|.data|.[]|.person|.email
.response|.data|.[]|.person|.gender
.response|.data|.[]|.person|.guid
.response|.data|.[]|.person|.id
.response|.data|.[]|.person|.isActive
.response|.data|.[]|.person|.name
.response|.data|.[]|.person|.phone
.response|.data|.[]|.person|.picture
.response|.data|.[]|.person|.registered
.response|.data|.[]|.person|.tags
.response|.data|.[]|.person|.tags|.[]
.response|.pagecount

```
This is a succinct representation of every simple path available through the json structure.


Example:
To see what the distribution of most common `tags` in that file

```
jq ".response|.data|.[]|.person|.tags|.[]" testdata.json | sort | uniq -c | sort -nr | head
     75 "est"
     64 "labore"
     63 "consectetur"
     58 "occaecat"
     57 "fugiat"
     57 "excepteur"
     56 "proident"
     56 "Lorem"
     56 "laborum"
     56 "incididunt"
```

Looks like they used [Lorem Ipsum](https://en.wikipedia.org/wiki/Lorem_ipsum) as filler.

Try for something more specific such as person's name and location.
```
jq ".response|.data|.[]|.person|.name,.coords" testdata.json | head
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

#### Result for genreating XML xpaths
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
./json2xpath.jq testdata.json |
    sort -u |
    xpath2dot.awk -v ORIENT="UD" |
    dot -T svg > testdata.svg

```

![testdata.svg](https://github.com/TomConlin/json2xpath/blob/master/testdata.svg)


--------

A note on the use of `sort -u` above

The script `json2xpath.jq` has the ability to sort and remove duplicates but they
are [commented out](https://github.com/TomConlin/json2xpath/blob/master/json2xpath.jq#L14).

They are disabled by default to allow more uses
for example:

 - We may be extracting data in some other program & want to know the native order
 - We may be interested in counts of things of various types

If you know these are not your use case you can uncomment them in the script
and eliminate piping the output through  `sort -u`

