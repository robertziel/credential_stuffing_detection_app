module Routes
  class Detect < Sinatra::Application
    before do
      content_type :json
    end

    put '/detect' do
      input = Input.new(input_params)

      if input.save
        { detected_attack: false }.to_json
      else
        { errors: input.errors.messages }.to_json
      end
    end

    private

    def input_params
      params.slice(:email, :event_name, :ip)
    end
  end
end
