module Transmo::RPC

  #
  # Per {transmission api specifications
  # }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L22]
  # Messages are formatted as objects
  #
  FORMAT = JSON

  #
  # Per {transmission api specifications
  # }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L27]
  # All text MUST be UTF-8 encoded
  #
  ENCODING = Encoding::UTF_8

  #
  # Per {transmission api specifications
  # }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L51]
  # the default URL as +http://host:9091/transmission/rpc+
  #
  DEFAULT_PATH = "/transmission/rpc"

  #
  # Per {transmission api specifications
  # }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L51]
  # the default URL as +http://host:9091/transmission/rpc+
  #
  DEFAULT_PORT = 9091

  #
  # Per {transmission api specifications
  # }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L58]
  # Most Transmission RPC servers require a X-Transmission-Session-Id
  #
  # It should be noted that this will mean submitting two requests when the
  # session ID expires
  # So, the correct way to handle a 409 response is to update your
  # X-Transmission-Session-Id and to resend the previous request.
  #
  SID_HEADER = "X-Transmission-Session-Id"
end

require_relative "rpc/request"
require_relative "rpc/torrent"
require_relative "rpc/session"
require_relative "rpc/queue"
