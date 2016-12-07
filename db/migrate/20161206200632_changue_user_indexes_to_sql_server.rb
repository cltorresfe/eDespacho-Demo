class ChangueUserIndexesToSqlServer < ActiveRecord::Migration
  def up
    remove_index :users, :email
    remove_index :users, :reset_password_token
    execute "CREATE UNIQUE NONCLUSTERED INDEX index_users_on_reset_password_token ON dbo.users (reset_password_token) WHERE reset_password_token IS NOT NULL;"
    execute "CREATE UNIQUE NONCLUSTERED INDEX index_users_on_email ON dbo.users (email) WHERE email IS NOT NULL;"
  end

  def down
    execute "DROP INDEX index_users_on_reset_password_token ON dbo.users;"
    execute "DROP INDEX index_users_on_email ON dbo.users;"
    add_index :users, :email, name: 'index_users_on_email', unique: true
    add_index :users, :reset_password_token, name: 'index_users_on_reset_password_token', unique: true
  end
end
