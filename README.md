# Transmo
A library for interfacing with a Transmission RPC

## Version

### Gem
<strong>0.0.0</strong>

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
