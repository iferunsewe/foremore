class AddSmsOptInToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sms_opt_in, :boolean, default: false
  end
end
