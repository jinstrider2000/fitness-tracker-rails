class AddProfilePicUrlAndRemoteProfilePicToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :profile_pic_url, :string
    add_column :users, :remote_profile_pic, :boolean, default: false
  end
end
