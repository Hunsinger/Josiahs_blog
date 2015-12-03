class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.string :string
      t.text :body
      t.references :article, index: true

      t.timestamps
    end
  end
end
