# A Handler to work with Rails 3.1 CSRF Authenticity Token Checks
module Trample
  class RailsHandler < BaseHandler

    def self.request_filter
      Proc.new do |session_id, url, params|
        params.merge!(:authenticity_token =>self.getVal(session_id, 'csrf_token'))
      end
    end

    def self.response_processor
      Proc.new do |session_id, html|
        if !html.nil?
          auth_token = Hpricot(html).at("meta[@name='csrf-token']")
          if !auth_token.nil?
            self.setVal(session_id, 'csrf_token', auth_token['content'])
          end
        end
      end
    end
  end
end