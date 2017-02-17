require "chef/http"
require "chef/http/authenticator"
require "chef/http/decompressor"
require "chef/http/cookie_manager"
require "chef/http/validate_content_length"
require "knife-art/basic_http"

class Chef
  class HTTP

    class SimpleBasicHTTP < HTTP

      def initialize(url, credentials = {})
        super(url, {})
        @credentials = credentials
        # This middleware will be called last
        @middlewares << BasicHTTP.new(@credentials[:login], @credentials[:password])
      end
      use JSONInput
      use JSONOutput
      use CookieManager
      use Decompressor
      use RemoteRequestID

      # ValidateContentLength should come after Decompressor
      # because the order of middlewares is reversed when handling
      # responses.
      use ValidateContentLength
    end
  end
end