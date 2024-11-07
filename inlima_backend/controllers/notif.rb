
require 'sinatra'
require_relative '../dao/user'

post '/notification-permission' do
  user_id = params[:user_id]
  permission_status = params[:notification_permission] == 'true'

  if UserDAO.update_notification_permission(user_id, permission_status)
    status 200
    json message: 'Permisos de notificaciones activadas.'
  else
    status 500
    json message: 'Error: no se pudo activar los permisos de notificaciones.'
  end
end
