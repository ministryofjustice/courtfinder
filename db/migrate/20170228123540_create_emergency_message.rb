class CreateEmergencyMessage < ActiveRecord::Migration
  def change
    create_table :emergency_messages do |t|
      t.boolean :show, default: false, :null => false
      t.text :message
    end
  end
end
