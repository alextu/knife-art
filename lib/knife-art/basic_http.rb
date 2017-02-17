class Chef
  class HTTP

    # HTTP middleware to add basic auth credentials on each request
    class BasicHTTP

      def initialize(login, password)
        @login = login
        @password = password
      end

      def handle_request(method, url, headers = {}, data = false)
        if @login && @password
          auth_header = {:Authorization => 'Basic ' + Base64.encode64("#{@login}:#{@password}")}
          headers = headers.merge auth_header
        end
        [method, url, headers, data]
      end

      def handle_response(http_response, rest_request, return_value)
        [http_response, rest_request, return_value]
      end

      def stream_response_handler(response)
        nil
      end

      def handle_stream_complete(http_response, rest_request, return_value)
        [http_response, rest_request, return_value]
      end

    end
  end
end
