lib_dir = File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift lib_dir if File.directory?(lib_dir)

require 'cloud_tunnel'

SLEEP_INTERVAL = 180

def kill_background_process(pid)
  begin
    Process.kill("TERM", pid)
    Process.wait(pid)
  rescue Errno::ECHILD
    # Child process is already dead
    true
  end
end

def start_tunnel_and_register_pid
  # Clean up if process was running previously
  kill_background_process(@pid) unless @pid.nil?

  # Open the tunnel
  @tunnel = CloudTunnel::start
  @pid = @tunnel.pid

  # Ensure the background processes get killed on exit
  at_exit do
    kill_background_process(@pid)
  end
end

# Run forever
loop do
  @tunnel ||=nil

  start_tunnel_and_register_pid unless @tunnel && @tunnel.connected?

  sleep(SLEEP_INTERVAL)
end
