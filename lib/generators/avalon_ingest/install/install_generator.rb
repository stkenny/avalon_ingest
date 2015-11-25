require 'rails/generators'
require 'rails/generators/migration'

module AvalonIngest
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "Add the migrations for AvalonIngest"

      def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migrations
        migration_template "create_table_ingest_batch.rb",
          "db/migrate/create_table_ingest_batch.rb"
        migration_template "create_table_media_objects.rb",
          "db/migrate/create_table_media_objects.rb"
        migration_template "create_table_master_files.rb",
          "db/migrate/create_table_master_files.rb" 
      end
    end
  end
end
