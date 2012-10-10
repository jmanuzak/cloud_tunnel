require 'net/http'
require 'uri'

module CloudTunnel
  class RedirectClient

    def create_or_update(source, destination)
      uri = URI('http://ctr.herokuapp.com/route')
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(:source => source, :destination => destination)

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
      end

      case res
      when Net::HTTPSuccess
        true
      else
        raise 'Could not update redirect server'
      end
    end

  end
end
