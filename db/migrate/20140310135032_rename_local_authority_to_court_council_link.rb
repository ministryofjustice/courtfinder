class RenameLocalAuthorityToCourtCouncilLink < ActiveRecord::Migration
  def change
    rename_table(:local_authorities, :court_council_links)
  end
end
