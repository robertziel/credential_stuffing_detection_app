module ResponseHelper
  def last_response_body_to_json
    response_body_to_json(last_response)
  end

  def response_body_to_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
