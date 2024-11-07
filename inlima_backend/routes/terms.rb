require 'sinatra'
require_relative '../dao/user_dao'

# Endpoint to update terms acceptance for a user
put '/user/:id/terms_accepted' do
  user_id = params[:id]
  terms_status = params[:terms_accepted] == 'true'

  if UserDAO.update_terms_accepted(user_id, terms_status)
    status 200
    { message: 'Terms acceptance updated successfully' }.to_json
  else
    status 500
    { message: 'Failed to update terms acceptance' }.to_json
  end
end
