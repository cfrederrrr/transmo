class Transmo::Client
  attr_accessor :try_refresh_max
  attr_reader :host

  def initialize(url, port: Transmo::RPC::DEFAULT_PORT, demo: false,
                 p_addr: :ENV,p_port: nil, p_user: nil, p_pass: nil)

    s, host = url.match(/(http(s)?:\/\/)?([^\/]+)/)[2,3]

    @host = host
    @target = "http#{s}://#{@host}"
    @try_refresh_max = 3

    if demo
      @demo = demo
      extend Transmo::Client::Demo
      return
    end

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
    elsif resp.is_a? Net::HTTPOK
      resptag = JSON.parse(resp.body)["tag"]
      if resptag == req.tag
        return true
      else
        raise Transmo::TagError,
          "response tag `#{resptag}' does not match request tag #{req.tag}!"
      end
    else
      raise Transmo::ResponseError,
        "#{self} could not understand the response #{resp} from #{@target}"
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

  private
  def validate_response_tag(req, resp)
  end

end
