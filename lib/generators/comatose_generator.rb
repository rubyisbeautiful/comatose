require 'rails/generators/base'
require 'rails/generators/active_record'
require 'rails/generators/migration'

class ComatoseGenerator < Rails::Generators::Base

  namespace :comatose
  source_root File.expand_path("../templates", __FILE__)

  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration


  def create_migration_file
    migration_template "migration.erb", "db/migrate/add_comatose_support.rb"
  end


  def create_init_file
    template "comatose.rb", "config/initializers/comatose.rb"
  end


  def copy_rake_files
    # TODO
  end


  def copy_assets
    # TODO
  end

end
