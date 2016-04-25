class AddRandomSecretToPhoto < ActiveRecord::Migration
  def change
  	add_column :photos,:random_secret, :string
  end
end
