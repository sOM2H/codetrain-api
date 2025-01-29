class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Required
      t.string :provider, null: false, default: "login"
      t.string :uid, null: false, default: ""

      ## Database authenticatable
      t.string :login, null: false
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, default: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_login

      # t.integer  :failed_attempts, default: 0, null: false
      # t.string   :unlock_token
      # t.datetime :locked_at

      ## User Info
      t.string :full_name

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :users, :login, unique: true
    add_index :users, [:uid, :provider], unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    # add_index :users, :unlock_token, unique: true
  end
end
