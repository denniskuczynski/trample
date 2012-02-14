module Trample
  class Configuration
    attr_reader :pages

    def initialize(&block)
      @pages = []
      instance_eval(&block)
    end

    def concurrency(*value)
      @concurrency = value.first unless value.empty?
      @concurrency
    end

    def iterations(*value)
      @iterations = value.first unless value.empty?
      @iterations
    end
    
    def delay(*value)
      @delay = value.first unless value.empty?
      @delay
    end
    
    def timeout(*value)
      @timeout = value.first unless value.empty?
      @timeout
    end

    def get(url, think_time=0, &block)
      @pages << Page.new(:get, url, think_time, block || {})
    end

    def post(url, think_time=0, params = nil, &block)
      @pages << Page.new(:post, url, think_time, params || block)
    end

    def login
      if block_given?
        yield
        @login = pages.pop
      end

      @login
    end

    def request_filter(&block)
      if block.is_a?(Proc)
        @request_filter = block
      end
      
      @request_filter
    end

    def response_processor(&block)
      if block.is_a?(Proc)
        @response_processor = block
      end
      
      @response_processor
    end

    def ==(other)
      other.is_a?(Configuration) &&
        other.pages == pages &&
        other.concurrency == concurrency &&
        other.iterations  == iterations &&
        other.delay  == delay &&
        other.timeout  == timeout &&
        other.request_filter  == request_filter &&
        other.response_processor  == response_processor
    end
  end
end
