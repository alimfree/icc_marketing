class RemindersAndKhateebs < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.references :khateeb, null: false, foreign_key: true
      t.text :caption
      t.string :title

      t.timestamps
    end
  end
end