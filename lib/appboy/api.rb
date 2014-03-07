module Appboy
  class API
    include HTTParty

    base_uri 'https://api.appboy.com'

    def initialize(secret, app_group_id)
      @secret, @app_group_id = secret, app_group_id
    end

    def track(attributes, events=[], purchases=[])
      post '/users/track', company_secret: @secret,
                           app_group_id:   @app_group_id,
                           attributes:     attributes,
                           events:         events,
                           purchases:      purchases
    end

    def send_message(message, user_ids, segment_id = nil)
      post '/messages/send', company_secret:    @secret,
                             app_group_id:      @app_group_id,
                             messages:          message,
                             external_user_ids: user_ids,
                             segment_ids:       [segment_id].compact
    end

    def schedule_message(date, message, segment_id, local_timezone=false)
      post '/messages/schedule', company_secret:            @secret,
                                 segment_ids:               [segment_id],
                                 send_at:                   date,
                                 deliver_in_local_timezone: local_timezone,
                                 messages:                  message
    end

  private
    def post(url, payload)
      response = self.class.post(url, query: payload)
      puts response.inspect
      response['message'] == 'success'
    end
  end
end
