#
# Per {transmission api specifications
# }[https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt#L49]
# HTTP POSTing a JSON-encoded request is the preferred way of
# communicating
#
class Transmo::RPC::Request < Net::HTTP::Post
  attr_reader :rpc_method, :rpc_tag

  ARGUMENTS = []

  def initialize(sid: nil, arguments: {}, method: self.class::RPC_METHOD)
    super Transmo::RPC::DEFAULT_PATH,
          Transmo::RPC::SID_HEADER => sid if sid

    @rpc_method = method
    @rpc_args = arguments
    @rpc_tag = self.hash % 100_000

    @rpc_args.keys.each do |key|
      unless self.class::ARGUMENTS.include? key.to_s
        @rpc_args[send("#{key}_rpckey")] = @rpc_args[key]
        @rpc_args.delete key
      end
    end

    @_body = {"method" => @rpc_method, "tag" => @rpc_tag}
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

  class << self
    protected

    def validate_response_tag
    end

    def convert_case(style, obj)
      str = obj.to_s

      unless str.match /^[a-zA-Z0-9\s_-]+$/
        raise ArgumentError, "#{obj} is not a valid string for parsing"
      end

      case style
      when :kebab
        while i = str =~ /[\s_A-Z]/
          if str[i].match /[A-Z]/
            str[i] = $&.downcase
            str.insert i, "-"
          else
            str[i] = "-"
          end
        end

      when :snake
        while i = str =~ /[-\sA-Z]/
          if str[i].match /[A-Z]/
            str[i] = $&.downcase
            str.insert i, "_"
          else
            str[i] = "_"
          end
        end

      when :camel
        while i = str =~ /[\s_-]/
          str.slice!(i)
          str[i] = str[i].upcase
        end
      end

      str.squeeze("-_")
    end

    def rpc2rb(arg)
      argstr = arg.dup.to_s
      argstr.gsub!("(B/s)", "bps")
      mname = convert_case :snake, argstr

      define_method mname do
        @_body[arg]
      end

      define_method "#{mname}=" do |val|
        @_body[arg] = val
      end

      define_method "#{mname}_rpckey" do
        arg
      end
      private "#{mname}_rpckey"
    end
  end
end
