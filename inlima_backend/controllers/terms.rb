
require 'sinatra'
require_relative '../dao/user'

post '/terms-accepted' do
  user_id = params[:user_id]
  terms_status = params[:terms_accepted] == 'true'

  if UserDAO.update_terms_accepted(user_id, terms_status)
    status 200
    json message: 'Terminos y condiciones exitosamente aceptados.'
  else
    status 500
    json message: 'Error: aceptación de los terminos y condiciones no se ha podido actualizar'
  end
end
