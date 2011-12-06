require 'action_dispatch/routing/mapper'

module Comatose
  module Routes

    def routes_for_comatose(opts={}, &block)
      Comatose.logger.debug("routes_for_comatose options: #{opts}")
      case
        when opts.empty?
          scope :module => "comatose" do
            constraints(LocaleConstraint) do
              match '/:locale/:page', :to => 'base#show'
              match '/:locale',       :to => 'base#show', :as => 'comatose_root'
            end
          end
        when opts[:mount]
          scope :module => "comatose" do
            constraints(LocaleConstraint) do
              match "/:locale/#{opts[:mount]}/:page", :to => 'base#show', :index => opts[:mount]
              match "/:locale/#{opts[:mount]}",       :to => 'base#show', :index => opts[:mount], :as => "#{opts[:mount].underscore}_comatose_root"
            end
          end
          Comatose.add_mount_point(opts[:mount], { :index => opts[:index] || '' })
      end
    end


    def admin_routes_for_comatose(opts={}, &block)
      Comatose.logger.debug("routes_for_comatose options: #{opts}")
      case
        when opts.empty?
          namespace(:comatose, :path => "/:locale/comatose") do
            constraints(LocaleConstraint) do
              match '', :to => 'admin#index'
              resources :pages, :controller => 'admin' do
                collection do
                  post :import
                  get :export, :expire
                end

                member do
                  get  :versions, :reorder
                  post :preview
                end
              end
            end
          end
        when opts[:mount]
          namespace(:comatose, :path => "/:locale/comatose") do
              constraints(LocaleConstraint) do
                match '', :to => 'admin#index'
                resources :pages, :controller => 'admin' do
                  collection do
                    post :import
                    get :export, :expire
                  end

                  member do
                    get  :preview, :versions, :reorder
                  end
                end
              end
            #end
          end
      end
    end


  end
end
