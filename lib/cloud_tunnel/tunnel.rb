require 'localtunnel'
require 'stringio'

module CloudTunnel
  class Tunnel
    TUNNEL_SERVICE_HOST_DOMAIN = 'localtunnel.com'

    KEY_FILE = '/Users/jmanuzak/.ssh/id_rsa.pub'
    PORT = 3000

    attr_reader :host, :pid

    def open_tunnel
      #capture_stdout do
        start_tunnel_in_background
      #end
    end

    def connected?
      return false unless @pid
      ping_tunnel && process_alive?(@pid)
    end

    def keep_alive
      ping_tunnel
    end

    private

    def start_tunnel_in_background
      key = File.open(KEY_FILE).read

      t = LocalTunnel::Tunnel.new(PORT, key)
      t.register_tunnel

      pid = fork { t.start_tunnel }

      @host = t.host
      @pid = pid

      Process.detach(@pid)
    end


    def process_alive?(pid)
      begin
        Process.getpgid(pid)
        true
      rescue Errno::ESRCH
        false
      end
    end

    def ping_tunnel
      url = "http://#{@host}.#{TUNNEL_SERVICE_HOST_DOMAIN}"
      uri = URI(url)
      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess
        true
      else
        false
      end
    end

    def capture_stdout
      previous_stdout, $stdout = $stdout, StringIO.new

      yield

      $stdout.string
    ensure
      $stdout = previous_stdout
    end
  end
end
