require_relative '../repository/base'
require_relative '../configs/models'

$user_repository = RepositoryBase.new(User)

module UserDAO
  def self.find_all
    $user_repository.find_all
  end

  def self.create(data)
    $user_repository.create(data)
  end

  def self.find_one(id)
    $user_repository.find_one(id)
  end

  def self.find_one_by_email(email)
    $user_repository.find_all(email: email).first
  end

  def self.update(data)
    $user_repository.update(data[:id], data)
  end

  def self.remove(id)
    $user_repository.remove(id)
  end

  def self.update_perfil(id, data)
    updated_user = $user_repository.update(id, data)
  rescue Sequel::Error => e
    puts "Error al actualizar perfil: #{e.message}"
    nil
  end

  def self.reset_password(id, password)
    user = find_one(id)
    raise 'Usuario no encontrado' unless user

    user.update(password: password)
    user
  end

  
  def self.update_notification_permission(id, permission_status)
    $user_repository.update(id, notification_permission: permission_status)
  rescue Sequel::Error => e
    puts "Error de permisos de notificaciones: #{e.message}"
    nil
  end

  # Method to update terms acceptance
  def self.update_terms_accepted(id, terms_status)
    $user_repository.update(id, terms_accepted: terms_status)
  rescue Sequel::Error => e
    puts "Error actualizando la aceptacion de terminos y condiciones: #{e.message}"
    nil
  end
end
