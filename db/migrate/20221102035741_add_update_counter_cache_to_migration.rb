class AddUpdateCounterCacheToMigration < ActiveRecord::Migration[6.1]
  def up
    Rake::Task['counters:update_shipments'].invoke
  end
end
