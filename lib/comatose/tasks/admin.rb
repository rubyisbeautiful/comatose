namespace :comatose do
  #
  # Customization Tasks
  #
  namespace :admin do

    desc "Create Comatose views, layouts, and public files..."
    task :customize do
      puts "Copying public files..."
      plugin_dir = File.join(File.dirname(__FILE__), '../../..')
      FileUtils.cp( 
        Dir[File.join(plugin_dir, 'resources', 'public', 'stylesheets', '*.css')], 
        File.join(RAILS_ROOT, 'public', 'stylesheets'),
        :verbose => true
      )
      FileUtils.cp( 
        Dir[File.join(plugin_dir, 'resources', 'public', 'javascripts', '*.js')], 
        File.join(RAILS_ROOT, 'public', 'javascripts'),
        :verbose => true
      )
      puts "Copying application views..."
      FileUtils.mkdir_p(File.join(RAILS_ROOT, 'app', 'views', 'comatose_admin'))
      FileUtils.cp( 
        Dir[File.join(plugin_dir, 'views', 'comatose_admin', '*.html.erb')], 
        File.join(RAILS_ROOT, 'app', 'views', 'comatose_admin'),
        :verbose => true
      )
      puts "Copying application layout..."
      FileUtils.cp( 
        File.join(plugin_dir, 'views', 'layouts', 'comatose_admin_customize.html.erb'), 
        File.join(RAILS_ROOT, 'app', 'views', 'layouts', 'comatose_admin.html.erb'),
        :verbose => true
      )
      puts "Finished."
    end


    desc "Removes the customized files... It doesn't ask for any confirmation, nor is it Subversion-safe -- so be warned!"
    task :teardown do
      puts "Removing public files..."
      FileUtils.rm(
        File.join(RAILS_ROOT, 'public', 'stylesheets', 'admin.css')
      )
      FileUtils.rm(
        File.join(RAILS_ROOT, 'public', 'javascripts', 'admin.js')
      )
    
      puts "Removing application views..."
      FileUtils.rm_rf(
        File.join(RAILS_ROOT, 'app', 'views', 'comatose_admin')
      )
      FileUtils.rm(
        File.join(RAILS_ROOT, 'app', 'views', 'layouts', 'comatose_admin.html.erb')
      )
    end
  end
end
