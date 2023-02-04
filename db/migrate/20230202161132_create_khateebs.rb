class CreateKhateebs < ActiveRecord::Migration[7.0]
  def change
    create_table :khateebs do |t|
      t.string :first_nm
      t.string :last_nm
      t.string :title
      t.string :email
      t.string :phone_number
      t.string :password_digest
      t.string :username

      t.timestamps
    end
  end
end
