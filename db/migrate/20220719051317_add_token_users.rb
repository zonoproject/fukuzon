class AddTokenUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :token, :string, default: ""
  end
end
