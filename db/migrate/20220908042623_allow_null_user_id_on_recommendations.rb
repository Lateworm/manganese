class AllowNullUserIdOnRecommendations < ActiveRecord::Migration[6.1]
  def change
    change_column_null :recommendations, :user_id, true
  end
end
