class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## 追加した情報
      t.string :nickname,              null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string   :image
      ## 追加した情報 ここまで

      t.timestamps
    end
  end
end
