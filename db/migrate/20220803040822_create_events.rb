class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :name
      t.timestamp :started_at

      t.timestamps
    end
  end
end
