class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_content_type, :string
  end
end
