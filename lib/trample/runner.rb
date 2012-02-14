module Trample
  class Runner
    include Logging

    attr_reader :config, :threads

    def initialize(config)
      @config  = config
      @threads = []
    end

    def trample
      logger.info "Starting trample... #{Time.now.getutc}"

      config.concurrency.times do |i|
        if @config.delay
          logger.info "Sleeping for #{@config.delay}"
          sleep(@config.delay)
        end
        thread = Thread.new(@config) do |c|
          session_time = Session.new(c, i).trample
          logger.info "SESSION #{i} #{session_time}"
        end
        threads << thread
      end

      threads.each { |t| t.join }

      logger.info "Trample completed... #{Time.now.getutc}"
    end
  end
end

