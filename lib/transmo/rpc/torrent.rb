module Transmo::Torrent
  module Action
    ARGUMENTS = ["ids"]
  end

  class Start < Transmo::RPC::Request
    include Transmo::Torrent::Action
    RPC_METHOD = "torrent-start"
    ARGUMENTS.each {|a| rpc2rb a}
  end

  class StartNow < Transmo::RPC::Request
    include Transmo::Torrent::Action
    RPC_METHOD = "torrent-start-now"
    ARGUMENTS.each {|a| rpc2rb a}
  end

  class Stop < Transmo::RPC::Request
    include Transmo::Torrent::Action
    RPC_METHOD = "torrent-stop"
    ARGUMENTS.each {|a| rpc2rb a}
  end

  class Verify < Transmo::RPC::Request
    include Transmo::Torrent::Action
    RPC_METHOD = "torrent-verify"
    ARGUMENTS.each {|a| rpc2rb a}
  end

  class Reannounce < Transmo::RPC::Request
    include Transmo::Torrent::Action
    RPC_METHOD = "torrent-reannounce"
    ARGUMENTS.each {|a| rpc2rb a}
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
    ].each {|a| rpc2rb a}
  end

  class Get < Transmo::RPC::Request
    RPC_METHOD = "torrent-get"
    ARGUMENTS = [
      "fields",
      "ids"
    ].each {|a| rpc2rb a}

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
    ].each {|a| rpc2rb a}
  end

  class Remove < Transmo::RPC::Request
    RPC_METHOD = "torrent-remove"
    ARGUMENTS = [
      "ids",
      "delete-local-data"
    ].each {|a| rpc2rb a}
  end

  class SetLocation < Transmo::RPC::Request
    RPC_METHOD = "torrent-set-location"
    ARGUMENTS = [
      "ids",
      "location",
      "move"
    ].each {|a| rpc2rb a}
  end

  class RenamePath < Transmo::RPC::Request
    RPC_METHOD = "torrent-rename-path"
    ARGUMENTS = [
      "ids",
      "path",
      "name"
    ].each {|a| rpc2rb a}
  end
end
