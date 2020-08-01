module Routes
  class Detect < Sinatra::Application
    before do
      content_type :json
    end

    put '/detect' do
      if input.save
        response_json
      else
        error_json
      end
    end

    private

    # input

    def input
      @input ||= Input.new(input_params)
    end

    def input_params
      @input_params ||= params.slice(:email, :event_name, :ip)
    end

    # responses

    def error_json
      { errors: input.errors.messages }.to_json
    end

    def response_json
      detected_attack = Input.detected_attack?(input_params)

      { detected_attack: detected_attack }.to_json
    end
  end
end
