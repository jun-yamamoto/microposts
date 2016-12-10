class Users < ActiveRecord::Migration
  def change
    add_column :users, :profile, :string
  end
end
