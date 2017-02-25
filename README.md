# Transmo
A library for interfacing with a Transmission RPC Server
Derived from [Transmission RPC-spec](https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt), I tried to get as close to verbatim as possible, but everyone writes bugs.

## Version

### Gem
<strong>0.0.2</strong>

### RPC
<strong>2.8</strong>

## Documentation
See the [Transmission RPC-spec](https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt) to learn the appropriate arguments for the RPC methods.

Full RDoc coming soon, but it will pretty much just be links to transmission's rpc spec.

## Usage
These two examples are effectively the same. The second gives you more granular control in case you don't already know what arguments you want the request to contain at the time of initialization.

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

```ruby
# create a raw request a la Net::HTTP subclasses
get = Transmo::Torrent::Get.new

# add arguments later
get.fields = ['name', 'activityDate']
get.ids = [*1..10]

# now that it's ready, submit the request via the client
transmo.request get
```

### Syntax
Arguments can be:
- `"strings"`
- `:symbols`
- `camelCase`
- `snake_case`
- `kebab-case`

kebab case must be exact string match for the RPC argument.

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

The demo client can run concurrently with a real client.

```ruby
demo = Transmo::Client.new '::', demo: true
# => #<Transmo::Client:0x007f8bbf0fafa8 @demo=true>
transmo = Transmo::Client.new ENV['TRANSMISSION_ADDR']
# => #<Transmo::Client:0x007fe1849a8a40 @host="127.0.0.1", @target="http://127.0.0.1", @try_refresh_max=3, @http=#<Net::HTTP 127.0.0.1:9091 open=false>, @sid="7TefPQ9O8eZ6uyKHy2qC7yH8bYMMPKnH8CB94DmaduTkJ0jY">
```
