module Routes
  class Detect < Sinatra::Application
    before do
      content_type :json
    end

    put '/detect' do
      if event_handler.save # TODO: It's not worth saving events if address is banned
        response_json
      else
        error_json
      end
    end

    private

    def event_handler
      @event_handler ||= EventHandler.new(event_params)
    end

    def event_params
      params.slice(:email, :event_name, :ip)
    end

    # responses

    def error_json
      { errors: event_handler.errors }.to_json
    end

    def response_json
      { detected_attack: event_handler.detected_attack? }.to_json
    end
  end
end
