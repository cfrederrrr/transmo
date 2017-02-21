require "net/http"
require "json"

#
#
#
module Transmo

  #
  #
  #
  module RPC

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
    # }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L49]
    # HTTP POSTing a JSON-encoded request is the preferred way of
    # communicating
    #
    class Request < Net::HTTP::Post
      attr_reader :rpc_method
      attr_reader :rpc_tag

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

      #
      #
      #
      ARGUMENTS = []

      def initialize(sid:, arguments: {}, method: self.class::RPC_METHOD)
        # p sid
        # p arguments
        # p method
        # p Transmo::RPC::DEFAULT_PATH
        # p SID_HEADER => sid
        super Transmo::RPC::DEFAULT_PATH, SID_HEADER => sid
              #self.class::METHOD,
              #self.class::REQUEST_HAS_BODY,
              #self.class::RESPONSE_HAS_BODY,

        @rpc_method = method
        @rpc_args = arguments

        @_body = {"method" => @rpc_method, "tag" => self.hash % 100_000}
        @_body["arguments"] = @rpc_args unless @rpc_args.empty?

        @body = @_body.to_json.encode(Transmo::RPC::ENCODING)
      end

      def to_json
        @body
      end

      def inspect
        JSON.pretty_generate(@_body)
      end

      private
      def validate_response_tag
      end

      def self.rpc2rb(*args)
        args.each do |arg|

          attribute = arg.dup
          attribute.gsub! /\W+/, "_"
          attribute.gsub! /_$/, ""
          attribute.scan(/[A-Z]/).each do |c|
            attribute.gsub! c, "_" + c.downcase
          end
          attribute.squeeze! "_"

          define_method "#{attribute}=" do |a|
            @rpc_args[arg] = a
          end

          define_method attribute do
            @rpc_args[arg]
          end

        end
      end
    end

    #
    #
    #
    class Response
      def initialize(result, arguments, tag)
        @result, @arguments, @tag = result, arguments, tag
      end
    end
  end

  #
  #
  #
  module Torrent
    module Action

      #
      #
      #
      ARGUMENTS = ["ids"]
    end

    #
    #
    #
    class Start < Transmo::RPC::Request
      include Transmo::Torrent::Action

      #
      #
      #
      RPC_METHOD = "torrent-start"
      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class StartNow < Transmo::RPC::Request
      include Transmo::Torrent::Action

      #
      #
      #
      RPC_METHOD = "torrent-start-now"
      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class Stop < Transmo::RPC::Request
      include Transmo::Torrent::Action

      #
      #
      #
      RPC_METHOD = "torrent-stop"
      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class Verify < Transmo::RPC::Request
      include Transmo::Torrent::Action

      #
      #
      #
      RPC_METHOD = "torrent-verify"
      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class Reannounce < Transmo::RPC::Request
      include Transmo::Torrent::Action

      #
      #
      #
      RPC_METHOD = "torrent-reannounce"
      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class Set < Transmo::RPC::Request

      #
      #
      #
      RPC_METHOD = "torrent-set"

      #
      #
      #
      ARGUMENTS = [
        "bandwidthPriority",
        "downloadLimit",
        "downloadLimited",
        "files-wanted",
        "files-unwanted",
        "honorsSessionLimits",
        "ids",
        "location",
        "peer-limit",
        "priority-high",
        "priority-low",
        "priority-normal",
        "queuePosition",
        "seedIdleLimit",
        "seedIdleMode",
        "seedRatioLimit",
        "seedRatioMode",
        "trackerAdd",
        "trackerRemove",
        "trackerReplace",
        "uploadLimit",
        "uploadLimited"
      ]

      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class Get < Transmo::RPC::Request

      #
      #
      #
      RPC_METHOD = "torrent-get"

      #
      #
      #
      ARGUMENTS = [
        "fields",
        "ids"
      ]

      #
      #
      #
      FIELDS = [
        "activityDate",
        "addedDate",
        "bandwidthPriority",
        "comment",
        "corruptEver",
        "creator",
        "dateCreated",
        "desiredAvailable",
        "doneDate",
        "downloadDir",
        "downloadedEver",
        "downloadLimit",
        "downloadLimited",
        "error",
        "errorString",
        "eta",
        "etaIdle",
        "files",
        "fileStats",
        "hashString",
        "haveUnchecked",
        "haveValid",
        "honorsSessionLimits",
        "id",
        "isFinished",
        "isPrivate",
        "isStalled",
        "leftUntilDone",
        "magnetLink",
        "manualAnnounceTime",
        "maxConnectedPeers",
        "metadataPercentComplete",
        "name",
        "peer-limit",
        "peers",
        "peersConnected",
        "peersFrom",
        "peersGettingFromUs",
        "peersSendingToUs",
        "percentDone",
        "pieces",
        "pieceCount",
        "pieceSize",
        "priorities",
        "queuePosition",
        "rateDownload (B/s)",
        "rateUpload (B/s)",
        "recheckProgress",
        "secondsDownloading",
        "secondsSeeding",
        "seedIdleLimit",
        "seedIdleMode",
        "seedRatioLimit",
        "seedRatioMode",
        "sizeWhenDone",
        "startDate",
        "status",
        "trackers",
        "trackerStats",
        "totalSize",
        "torrentFile",
        "uploadedEver",
        "uploadLimit",
        "uploadLimited",
        "uploadRatio",
        "wanted",
        "webseeds",
        "webseedsSendingToUs"
      ]

      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class Add < Transmo::RPC::Request

      #
      #
      #
      RPC_METHOD = "torrent-add"

      #
      #
      #
      ARGUMENTS = [
        "cookies",
        "download-dir",
        "filename",
        "metainfo",
        "paused",
        "peer-limit",
        "bandwidthPriority",
        "files-wanted",
        "files-unwanted",
        "priority-high",
        "priority-low",
        "priority-normal"
      ]

      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class Remove < Transmo::RPC::Request

      #
      #
      #
      RPC_METHOD = "torrent-remove"

      #
      #
      #
      ARGUMENTS = [
        "ids",
        "delete-local-data"
      ]

      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class SetLocation < Transmo::RPC::Request

      #
      #
      #
      RPC_METHOD = "torrent-set-location"

      #
      #
      #
      ARGUMENTS = [
        "ids",
        "location",
        "move"
      ]

      rpc2rb *ARGUMENTS
    end

    #
    #
    #
    class RenamePath < Transmo::RPC::Request

      #
      #
      #
      RPC_METHOD = "torrent-rename-path"

      #
      #
      #
      ARGUMENTS = [
        "ids",
        "path",
        "name"
      ]

      rpc2rb *ARGUMENTS
    end
  end

  #
  #
  #
  module Session

    #
    #
    #
    class Request < Transmo::RPC::Request

      #
      #
      #
      ARGUMENTS = [
        "alt-speed-down",
        "alt-speed-enabled",
        "alt-speed-time-begin",
        "alt-speed-time-enabled",
        "alt-speed-time-end",
        "alt-speed-time-day",
        "alt-speed-up",
        "blocklist-url",
        "blocklist-enabled",
        "blocklist-size",
        "cache-size-mb",
        "config-dir",
        "download-dir",
        "download-queue-size",
        "download-queue-enabled",
        "dht-enabled",
        "encryption",
        "idle-seeding-limit",
        "idle-seeding-limit-enabled",
        "incomplete-dir",
        "incomplete-dir-enabled",
        "lpd-enabled",
        "peer-limit-global",
        "peer-limit-per-torrent",
        "pex-enabled",
        "peer-port",
        "peer-port-random-on-start",
        "port-forwarding-enabled",
        "queue-stalled-enabled",
        "queue-stalled-minutes",
        "rename-partial-files",
        "rpc-version",
        "rpc-version-minimum",
        "script-torrent-done-filename",
        "script-torrent-done-enabled",
        "seedRatioLimit",
        "seedRatioLimited",
        "seed-queue-size",
        "seed-queue-enabled",
        "speed-limit-down",
        "speed-limit-down-enabled",
        "speed-limit-up",
        "speed-limit-up-enabled",
        "start-added-torrents",
        "trash-original-torrent-files",
        "units",
        "utp-enabled",
        "version"
      ]
    end

    #
    #
    #
    class Set < Transmo::Session::Request

      #
      #
      #
      RPC_METHOD = "session-set"

      #
      #
      #
      exceptions = [
        "blocklist-size",
        "config-dir",
        "rpc-version",
        "rpc-version-minimum",
        "version"
      ]

      rpc2rb *ARGUMENTS - exceptions
    end

    #
    #
    #
    class Get < Transmo::Session::Request

      #
      #
      #
      RPC_METHOD = "session-get"
    end

    #
    #
    #
    class Stats < Transmo::Session::Request

      #
      #
      #
      RPC_METHOD = "session-stats"
    end

    class Close < Transmo::RPC::Request

      #
      #
      #
      RPC_METHOD = "session-close"

      rpc2rb *ARGUMENTS
    end
  end

  #
  #
  #
  module Queue

    #
    #
    #
    class Request

      #
      #
      #
      ARGUMENTS = ["ids"]
    end

    #
    #
    #
    class MoveTop < Transmo::Queue::Request

      #
      #
      #
      RPC_METHOD = "queue-move-top"
    end

    #
    #
    #
    class MoveUp < Transmo::Queue::Request

      #
      #
      #
      RPC_METHOD = "queue-move-up"
    end

    #
    #
    #
    class MoveDown < Transmo::Queue::Request

      #
      #
      #
      RPC_METHOD = "queue-move-down"
    end

    #
    #
    #
    class MoveBottom < Transmo::Queue::Request

      #
      #
      #
      RPC_METHOD = "queue-move-bottom"
    end
  end

  #
  #
  #
  class Client

    def initialize(hostname)
      hostname.gsub!(/https?:\/\//, '')
      @uri = URI.parse "http://#{hostname}:#{Transmo::RPC::DEFAULT_PORT}"
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @sid = @http.head(Transmo::RPC::DEFAULT_PATH)["X-Transmission-Session-Id"]
    end

    attr_accessor :uri

    def blocklist
      req = Transmo::RPC::Request.new sid: @sid, method: "blocklist-update"
      @http.request req
    end

    def port_test
      req = Transmo::RPC::Request.new sid: @sid, method: "port-test"
      @http.request req
    end

    def free_space(path)
      req = Transmo::RPC::Request.new sid: @sid, method: "free-space"
      @http.request req
    end

    def torrent(sym, args = {})
      klass = Transmo::Torrent.const_get sym.capitalize
      req = klass.new sid: @sid, arguments: args
      @http.request req
    end

    def session(sym, args = {})
      klass = Transmo::Session.const_get sym.capitalize
      req = klass.new sid: @sid, arguments: args
      @http.request req
    end

    def queue(sym, args = {})
      klass = Transmo::Queue.const_get sym.capitalize
      req = klass.new sid: @sid, arguments: args
      @http.request req
    end
  end

end
