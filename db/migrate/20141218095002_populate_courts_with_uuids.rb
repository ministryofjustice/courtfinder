class PopulateCourtsWithUuids < ActiveRecord::Migration
  def up
    Rake::Task['import:uuids'].invoke
  end

  def down
    execute "UPDATE courts SET uuid=NULL"
  end
end
