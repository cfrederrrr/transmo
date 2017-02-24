module Transmo::Session
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
    (ARGUMENTS - exceptions).each {|a| rpc2rb a}
  end

  class Get < Transmo::Session::Request
    RPC_METHOD = "session-get"
    ARGUMENTS.each {|a| rpc2rb a}
  end

  class Stats < Transmo::Session::Request
    RPC_METHOD = "session-stats"
    ARGUMENTS.each {|a| rpc2rb a}
  end

  class Close < Transmo::RPC::Request
    RPC_METHOD = "session-close"
    ARGUMENTS.each {|a| rpc2rb a}
  end
end
