module Transmo::Queue
  class Request < Transmo::RPC::Request
    ARGUMENTS = ["ids"].each {|a| rpc2rb a}
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
