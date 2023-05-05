class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.belongs_to :user
      t.string :task_type 
      t.text :description
      t.decimal :latitude, precision: 10, scale: 2
      t.decimal :longitude, precision: 10, scale: 2
      t.string :status
      t.timestamps
    end
  end
end
