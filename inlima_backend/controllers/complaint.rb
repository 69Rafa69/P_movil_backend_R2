require 'json'
require_relative '../helpers/auth_helper'
require_relative '../DAO/complaint'
require_relative '../DAO/citizen'
require_relative '../DAO/district'
require_relative '../DAO/photos'
require_relative '../DAO/administrator'

class ComplaintController
  include AuthHelper

  def add_complaint(token, data)
    usuario = verificar_token(token)
    ciudadano = CitizenDAO.find_one_by_user_id(usuario[:id])

    if ciudadano
      queja = ComplaintDAO.create({
        description: data[:description],
        location_description: data[:location_description],        
        latitude: data[:latitude],
        longitude: data[:longitude],
        status_id: 1,
        citizen_id: ciudadano[:id],
        district_id: data[:district],
        subject_id: data[:subject]
      })
      
      if queja
        data[:photos].each do |photo_url|
          PhotoDAO.create({
            url: photo_url,
            complaint_id: queja[:id]
          })
        end
        { success: true, message: "Queja enviada", data: queja }.to_json
      else
        { success: false, message: "Error al crear la queja" }.to_json
      end
    else
      { success: false, message: "Ciudadano no encontrado" }.to_json
    end
  end

  def encontrar_ubicacion(queja_id)
    queja = ComplaintDAO.find_one(queja_id)
    if queja
      { success: true, message: queja[:location_description] }.to_json
    else
      { success: false, message: 'Queja no encontrada' }.to_json
    end
  end

  def encontrar_distrito(queja_id)
    queja = ComplaintDAO.find_one(queja_id)
    if queja
      district = DistrictDAO.find_one(queja[:district_id])
      { success: true, message: district[:name] }.to_json
    else
      { success: false, message: 'Queja no encontrada' }.to_json
    end
  end

  def obtener_quejas_filtradas(token, filtros)
    usuario = verificar_token(token)
    admin = AdministratorDAO.find_one_by_user_id(usuario[:id])

    if admin
      condiciones = construir_condiciones_filtro(filtros, admin)
      quejas = ComplaintDAO.find_filtered(condiciones)
      { success: true, data: quejas }.to_json
    else
      { success: false, message: 'Acceso denegado' }.to_json
    end
  end
  
  def obtener_queja_con_detalles(id)
    queja = ComplaintDAO.find_one_by_citizen_id(id)
    if queja
      { success: true, data: queja }.to_json
    else
      { success: false, message: "Queja no encontrada" }.to_json
    end
  end

  def obtener_quejas_usuario(token)
    usuario = verificar_token(token)
    ciudadano = CitizenDAO.find_one_by_user_id(usuario[:id])

    if ciudadano
      quejas = ComplaintDAO.find_all_by_citizen_id(ciudadano[:id])
      { success: true, data: quejas }.to_json
    else
      { success: false, message: "Quejas no encontradas" }.to_json
    end
  end
end