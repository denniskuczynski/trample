module Trample
  class Runner
    include Logging
    include Timer

    attr_reader :config, :threads

    def initialize(config)
      @config  = config
      @threads = []
    end

    def trample
      logger.info "Trample starting..."

      trample_time = time do
        config.concurrency.times do |i|
          if @config.delay and @config.delay > 0
            logger.info "Delaying Session for #{@config.delay}"
            sleep(@config.delay)
          end
          thread = Thread.new(@config) do |c|
            session_time = Session.new(c, i).trample
            logger.info "SESSION #{i} #{session_time}"
          end
          threads << thread
        end

        threads.each { |t| t.join }
      end

      logger.info "TRAMPLE #{trample_time}"
      logger.info "Trample completed..."
    end
  end
end

