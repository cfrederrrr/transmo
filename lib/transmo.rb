require "net/https"
require "json"

module Transmo
  ResponseError = Class.new StandardError
  NoSessionError = Class.new Transmo::ResponseError
  TagError = Class.new Transmo::ResponseError
end

require_relative "transmo/version"
require_relative "transmo/rpc"
require_relative "transmo/client"
require_relative "transmo/demo"
