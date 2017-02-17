require 'base64'

module Knife
  module KnifeArt
    class KnifeArtUtils

      def self.credentials_from(uri)
        Chef::Log.debug("[KNIFE-ART] in util, got url: #{uri}")
        begin
        url = URI.parse(uri.gsub(%r{/+$}, ""))
        Chef::Log.debug("[KNIFE-ART] in util, parsed url: #{uri}")
        if url.user and url.password
          user = URI.unescape(url.user)
          password = URI.unescape(url.password)
          return { :login => user, :password => password }
        end
        {}
        end
      rescue Exception => e
        Chef::Log.warn("[KNIFE-ART] Unable to parse url: #{uri} --> #{e.message}")
        {}
      end

    end

  end
end
