class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.belongs_to :user
      t.belongs_to :conversation
      t.text :content
      t.timestamps
    end
  end
end
