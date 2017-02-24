require "net/https"
require "json"

module Transmo
  NoSessionError = Class.new StandardError
  NoMethodError = Class.new ::NoMethodError
end

require_relative "transmo/version"
require_relative "transmo/rpc"
require_relative "transmo/client"
