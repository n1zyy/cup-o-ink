class CreatePrintServers < ActiveRecord::Migration
  def change
    create_table :print_servers do |t|

      t.timestamps
    end
  end
end
