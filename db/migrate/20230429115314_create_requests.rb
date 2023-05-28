class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.belongs_to :user
      t.string :title
      t.string :task_type 
      t.text :description
      t.decimal :latitude, precision: 15, scale: 10
      t.decimal :longitude, precision: 15, scale: 10
      t.string :status, default: "Unfilled" 
      t.integer :user_counter, default: 0
      t.boolean :closed, default: false 
      t.datetime :published_at


      t.timestamps
    end
  end
end
