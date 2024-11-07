require 'sinatra'
require_relative '../dao/user_dao'

# Endpoint to update notification permission for a user
put '/user/:id/notification_permission' do
  user_id = params[:id]
  permission_status = params[:notification_permission] == 'true'

  if UserDAO.update_notification_permission(user_id, permission_status)
    status 200
    { message: 'Notification permission updated successfully' }.to_json
  else
    status 500
    { message: 'Failed to update notification permission' }.to_json
  end
end
