module Routes
  class App < Sinatra::Application
    before do
      content_type :json
    end

    put '/detect' do
      { result: false }.to_json
    end
  end
end
