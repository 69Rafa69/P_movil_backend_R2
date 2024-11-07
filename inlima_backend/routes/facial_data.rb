
require 'sinatra'
require_relative '../controllers/facial_data.rb'


get '/facial_data' do
  result = FacialDataController.find_all
  result.to_json
end


post '/facial_data' do
  data = JSON.parse(request.body.read)
  result = FacialDataController.create(data)
  status result ? 201 : 400
  result.to_json
end


get '/facial_data/:id' do
  result = FacialDataController.find_one(params[:id].to_i)
  if result
    status 200
    result.to_json
  else
    status 404
    { error: "Facial data not found" }.to_json
  end
end


put '/facial_data/:id' do
  data = JSON.parse(request.body.read).merge({ id: params[:id].to_i })
  result = FacialDataController.update(data)
  if result
    status 200
    result.to_json
  else
    status 400
    { error: "Failed to update facial data" }.to_json
  end
end


delete '/facial_data/:id' do
  result = FacialDataController.remove(params[:id].to_i)
  if result
    status 204
  else
    status 404
    { error: "Facial data not found" }.to_json
  end
end
