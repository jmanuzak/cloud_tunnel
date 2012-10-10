require "cloud_tunnel/version"
require "cloud_tunnel/tunnel"
require "cloud_tunnel/redirect_client"

module CloudTunnel
  extend self

  def start
    # Open tunnel
    tunnel = CloudTunnel::Tunnel.new
    tunnel.open_tunnel

    # Register tunnel address with CloudTunnel service
    redirect_client = CloudTunnel::RedirectClient.new
    redirect_client.create_or_update('jmtest', tunnel.host)

    return tunnel
  end
end
