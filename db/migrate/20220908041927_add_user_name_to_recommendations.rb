class AddUserNameToRecommendations < ActiveRecord::Migration[6.1]
  def change
    add_column :recommendations, :user_name, :string
  end
end
