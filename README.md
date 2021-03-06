# JV: JSON Value extractor

This is a simple commandline tool for extracting a particular value from
a JSON data structure.

Suppose you have the following JSON file:

```json
{
  "one": {
    "name": "example"
  },
  "two": {
    "legit":[ "start", "stop", "quit"]
  }
}
```

Using `jv`, you can query a particular part of the JSON by path.

```
$ jv /two/legit/2 example2.json
"quit"
```

As you can see, paths match my mapping either names or array indices.

JV also allows you to extra subsections of JSON:

```
$ jv /two example2.json
{"legit":["start","stop","quit"]}
```

If you give JV multiple files, it will run the query on every file, and
produce a line of output for each:

```
$ jv /this example2.json example.json
null
{"is":{"the":{"way":{"the":{"world":"ends"}}}}}
```

## Future

In the future, we'll hopefully support:

- POSIX regular expressions
- Relative paths
- Better error handling

## Building

To build, you will need the Elixir runtime. From there, you can check
out this project, and then run:

```
$ mix deps.get
$ mix escript.build
```

This will create the `jv` escript file, which is an embedded Erlang
script. Any machine that has the Erlang runtime can run then run `jv`.
