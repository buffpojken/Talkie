class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string    :name
      t.string    :host
      t.string    :subdomain
      t.string    :auth_hash
      t.integer   :user_id
      t.timestamps
    end
  end
end
