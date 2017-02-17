# Overrides the default Chef::Knife::CookbookSiteShare to allow basic authentication against an Artifactory backend.
# Ideally we would like to use a mechanism that allows injecting pluggable authentication middleware into the Chef::Http
# REST clients, but in the interest of allowing not-only-newest knife client versions to work with Artifactory we chose
# this solution for now.

require 'chef/knife'
require 'chef/knife/cookbook_site_download'
require 'knife-art/knife_art_utils'

class Chef
  class Knife
    class ArtifactoryDownload < Knife::CookbookSiteDownload

      dependency_loaders.concat(superclass.dependency_loaders)
      options.merge!(superclass.options)

      banner "knife artifactory download COOKBOOK [VERSION] (options)"
      category "artifactory"

      alias_method :orig_run, :run
      alias_method :orig_noauthrest, :noauth_rest

      def noauth_rest
        unless config[:artifactory_download]
          Chef::Log.debug('[KNIFE-ART] ArtifactoryDownload::noauth_rest called without artifactory flag, delegating to super')
          return orig_noauthrest
        end
        @rest ||= begin
          require "knife-art/simple_basic_http"
          Chef::HTTP::SimpleBasicHTTP.new(Chef::Config[:chef_server_url], auth_credentials)
        end
      end

      def run
        config[:artifactory_download] = true
        Chef::Log.debug("[KNIFE-ART] running site download with config: #{config}")
        orig_run
      end

      private

      def auth_credentials
        @auth_credentials ||= begin
                            ::Knife::KnifeArt::KnifeArtUtils.credentials_from(cookbooks_api_url)
                         end
      end

    end
  end
end
