require "net/https"
require "json"

module Transmo

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
    # Per {transmission api specifications
    # }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L49]
    # HTTP POSTing a JSON-encoded request is the preferred way of
    # communicating
    #
    class Request < Net::HTTP::Post
      attr_reader :rpc_method, :rpc_tag

      ARGUMENTS = []

      def initialize(sid: nil, arguments: {}, method: self.class::RPC_METHOD)
        super Transmo::RPC::DEFAULT_PATH,
              Transmo::RPC::SID_HEADER => sid if sid

        @rpc_method = method
        @rpc_args = arguments
        @rpc_tag = self.hash % 100_000

        @_body = {"method" => @rpc_method, "tag" => @tag}
        @_body["arguments"] = @rpc_args unless @rpc_args.empty?

        @body = @_body.to_json.encode(Transmo::RPC::ENCODING)
      end

      def tag
        @tag
      end

      def tag=(tag)
        @_body["tag"] = @tag = tag
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

      def self._s2rpc(sym)
        key = sym.to_s
        key.gsub!(/_bps/, "\s(B/s)")
        key.gsub!('_', '-')
      end

    end
  end

  module Torrent
    module Action

      ARGUMENTS = ["ids"]
    end

    class Start < Transmo::RPC::Request
      include Transmo::Torrent::Action

      RPC_METHOD = "torrent-start"
    end

    class StartNow < Transmo::RPC::Request
      include Transmo::Torrent::Action

      RPC_METHOD = "torrent-start-now"
    end

    class Stop < Transmo::RPC::Request
      include Transmo::Torrent::Action

      RPC_METHOD = "torrent-stop"
    end

    class Verify < Transmo::RPC::Request
      include Transmo::Torrent::Action

      RPC_METHOD = "torrent-verify"
    end

    class Reannounce < Transmo::RPC::Request
      include Transmo::Torrent::Action

      RPC_METHOD = "torrent-reannounce"
    end

    class Set < Transmo::RPC::Request

      RPC_METHOD = "torrent-set"

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
    end

    class Get < Transmo::RPC::Request

      RPC_METHOD = "torrent-get"

      ARGUMENTS = [
        "fields",
        "ids"
      ]

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
    end

    class Add < Transmo::RPC::Request

      RPC_METHOD = "torrent-add"

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
    end

    class Remove < Transmo::RPC::Request

      RPC_METHOD = "torrent-remove"

      ARGUMENTS = [
        "ids",
        "delete-local-data"
      ]
    end

    class SetLocation < Transmo::RPC::Request

      RPC_METHOD = "torrent-set-location"

      ARGUMENTS = [
        "ids",
        "location",
        "move"
      ]
    end

    class RenamePath < Transmo::RPC::Request

      RPC_METHOD = "torrent-rename-path"

      ARGUMENTS = [
        "ids",
        "path",
        "name"
      ]
    end
  end

  module Session

    class Request < Transmo::RPC::Request

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

    class Set < Transmo::Session::Request

      RPC_METHOD = "session-set"

      exceptions = [
        "blocklist-size",
        "config-dir",
        "rpc-version",
        "rpc-version-minimum",
        "version"
      ]
    end

    class Get < Transmo::Session::Request

      RPC_METHOD = "session-get"
    end

    class Stats < Transmo::Session::Request

      RPC_METHOD = "session-stats"
    end

    class Close < Transmo::RPC::Request

      RPC_METHOD = "session-close"
    end
  end

  module Queue

    class Request

      ARGUMENTS = ["ids"]
    end

    class Movetop < Transmo::Queue::Request

      RPC_METHOD = "queue-move-top"
    end

    class Moveup < Transmo::Queue::Request

      RPC_METHOD = "queue-move-up"
    end

    class Movedown < Transmo::Queue::Request

      RPC_METHOD = "queue-move-down"
    end

    class Movebottom < Transmo::Queue::Request

      RPC_METHOD = "queue-move-bottom"
    end
  end


  NoSessionError = Class.new StandardError

  class Client
    attr_accessor :try_refresh_max
    attr_reader :host

    def initialize(url, port: Transmo::RPC::DEFAULT_PORT, p_addr: :ENV,
                   p_port: nil, p_user: nil, p_pass: nil)

      s, host = url.match(/(http(s)?:\/\/)?([^\/]+)/)[2,3]

      @host = host
      @target = "http#{s}://#{@host}"
      @try_refresh_max = 3
      @http = Net::HTTP.new host, port, p_addr, p_port, p_user, p_pass

      if s
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      get_fresh_session
    end

    def blocklist
      req = Transmo::RPC::Request.new sid: @sid, method: "blocklist-update"
      request req
    end

    def port_test
      req = Transmo::RPC::Request.new sid: @sid, method: "port-test"
      request req
    end

    def free_space(path)
      req = Transmo::RPC::Request.new sid: @sid, method: "free-space"
      request req
    end

    def torrent(sym, args = {})
      klass = Transmo::Torrent.const_get sym.capitalize
      req = klass.new sid: @sid, arguments: args
      request req
    end

    def session(sym, args = {})
      klass = Transmo::Session.const_get sym.capitalize
      req = klass.new sid: @sid, arguments: args
      request req
    end

    def queue(sym, args = {})
      klass = Transmo::Queue.const_get sym.capitalize
      req = klass.new sid: @sid, arguments: args
      request req
    end

    def request(req)
      resp = @http.request req

      if resp.is_a? Net::HTTPConflict
        get_fresh_session
        resp = @http.request req
      end

      resp
    end

    def get_fresh_session(attempts = 0)
      head_resp = @http.head(Transmo::RPC::DEFAULT_PATH)
      unless @sid = head_resp[Transmo::RPC::SID_HEADER]

        if attempts >= @try_refresh_max
          raise Transmo::NoSessionError,
            "unable to establish session with `#{@target}'"
        else
          get_fresh_session attempts + 1
        end

      end
    end

  end
end
