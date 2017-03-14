class CreateOpenGuideTable < ActiveRecord::Migration
  def change
    create_table :open_guide_tables do |t|
    	t.integer :folio
    end
  end
end
