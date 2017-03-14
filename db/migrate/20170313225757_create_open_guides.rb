class CreateOpenGuides < ActiveRecord::Migration
  def change
    create_table :open_guides do |t|

      t.timestamps
      t.integer :folio
      drop_table :open_guide_tables
    end
  end
end
