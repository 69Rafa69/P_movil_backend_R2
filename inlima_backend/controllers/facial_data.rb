require 'sinatra'
require_relative '../dao/facialdata.rb'

class FacialDataController < Sinatra::Base
  
  post '/facial_data' do
    data = JSON.parse(request.body.read)
    facial_data = FacialDataDAO.create(data)
    if facial_data
      status 201
      facial_data.to_json
    else
      status 422
      { error: 'No se pudo crear facial data' }.to_json
    end
  end

  # Route to fetch all facial data entries
  get '/facial_data' do
    facial_data = FacialDataDAO.find_all
    facial_data.to_json
  end

  # Route to fetch facial data by id
  get '/facial_data/:id' do
    id = params['id']
    facial_data = FacialDataDAO.find_one(id)
    if facial_data
      facial_data.to_json
    else
      status 404
      { error: 'Facial data no encontrada' }.to_json
    end
  end

  # Route to update facial data by id
  put '/facial_data/:id' do
    id = params['id']
    data = JSON.parse(request.body.read).merge({ id: id.to_i })
    updated_data = FacialDataDAO.update(data)
    if updated_data
      updated_data.to_json
    else
      status 422
      { error: 'No se pudo actualizar la facial data' }.to_json
    end
  end

  # Route to delete facial data by id
  delete '/facial_data/:id' do
    id = params['id']
    if FacialDataDAO.remove(id)
      status 204
    else
      status 422
      { error: 'No se pudo borrar la facial data' }.to_json
    end
  end
end
