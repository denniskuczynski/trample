# A Base Implementation for RequestFilters and ResponseProcessors that store Data in a Hash with Session.id
module Trample
  class BaseHandler
    @@session_store = Hash.new

    def self.getVal(session_id, key)
      @@session_store[key]
    end

    def self.setVal(session_id, key, val)
      @@session_store[key] = val
    end
  
    def self.request_filter
      nil
    end

    def self.response_processor
      nil
    end
  end
end