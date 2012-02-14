module Trample
  class Session
    include Logging
    include Timer
    
    attr_reader :id, :config, :response_times, :cookies, :last_response

    HTTP_ACCEPT_HEADER = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"

    def initialize(config, instance_number)
      @id = instance_number
      @config         = config
      @cookies        = {}
    end

    def trample
      time do
        hit @config.login unless @config.login.nil?
        @config.iterations.times do
          iteration_time = time do
            @config.pages.each do |p|
              hit p
            end
          end
          logger.info "ITERATION #{@id} #{iteration_time}"
        end
      end
    end

    protected
      def hit(page)
        response_time = request(page)
        # this is ugly, but it's the only way that I could get the test to pass
        # because rr keeps a reference to the arguments, not a copy. ah well.
        @cookies = cookies.merge(last_response.cookies)

        was_timeout = false
        if @config.timeout
          was_timeout = response_time > @config.timeout
        end
        logger.info "#{page.request_method.to_s.upcase} #{page.url} #{response_times.last}s #{last_response.code} #{was_timeout}"
      end

      def request(page)
        time do
          @last_response = send(page.request_method, page)
          if @config.response_processor
            @config.response_processor.call(@session_id, @last_response)
          end
        end
      end

      def get(page)
        url = page.url
        params = page.parameters
        if @config.request_filter
          @config.request_filter.call(@session_id, url, params)
        end
        RestClient.get(url, :cookies => cookies, :accept => HTTP_ACCEPT_HEADER)
      end

      def post(page)
        url = page.url
        params = page.parameters
        if @config.request_filter
          @config.request_filter.call(@session_id, url, params)
        end
        RestClient.post(url, page.parameters, :cookies => cookies, :accept => HTTP_ACCEPT_HEADER)
      end
  end
end
