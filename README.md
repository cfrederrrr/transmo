# Transmo
A library for interfacing with a Transmission RPC

## Version

### Gem
<strong>0.0.2</strong>

### RPC
<strong>2.8</strong>

## Documentation
See the [Transmission RPC-spec](https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt) to learn the appropriate arguments for the RPC methods.


## Usage
```ruby
require 'transmo'

# establish client
transmo = Transmo::Client.new ENV['TRANSMISSION_ADDR']

# check port
transmo.port_test

# look at session settings
transmo.session :get

# look at the name and activity date of the first 10 torrents in your list
transmo.torrent :get, fields: ['name', 'activityDate'], ids: [*1..10]
```

### Demo client!
This client will not submit requests under any circumstance. Instead it will simply create a request object and pretty print the JSON body. This can be very handy for troubleshooting request-formats in irb (or not!).

```ruby
require 'transmo'

transmo = Transmo::Client.new '::', demo: true

transmo.torrent :get, ids: [*1..4], fields: ['name', 'id']
```

will automatically print this to stdout

```json
{
  "method": "torrent-get",
  "tag": 22917,
  "arguments": {
    "ids": [
      1,
      2,
      3,
      4
    ],
    "fields": [
      "name",
      "id"
    ]
  }
}
```

### Syntax
Arguments can be:
- `"strings"`
- `:symbols`
- `camelCase`
- `snake_case`
- `kebab-case` (kebab case must be exact match string)

``` ruby
# all of these produce the same request
transmo.torrent :set, ids: [*1..3], seed_ratio_limit: 2.5
transmo.torrent :set, ids: [*1..3], seedRatioLimit: 2.5
transmo.torrent :set, ids: [*1..3], "seed_ratio_limit" => 2.5
transmo.torrent :set, ids: [*1..3], "seedRatioLimit" => 2.5
```

```json
{
  "method": "torrent-set",
  "tag": 44816,
  "arguments": {
    "ids": [
      1,
      2,
      3
    ],
    "seedRatioLimit": 2.5
  }
}
```

This is strictly cosmetic, as the client parses your input to look up the key expected by the RPC server.
If you're not sure what arguments are available, you can jump into `irb` and...

```ruby
require 'transmo'
Transmo::Torrent::Get::ARGUMENTS
Transmo::Torrent::Set::ARGUMENTS
Transmo::Session::Get::ARGUMENTS
# etc...
```
to see what the RPC server is expecting.
