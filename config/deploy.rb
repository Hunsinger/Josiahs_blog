# config valid only for current version of Capistrano
lock '3.4.0'

require "whenever/capistrano"

set :application, 'blog'
set :repo_url, 'https://Hunsinger:Chelsea1024@github.com/Hunsinger/Js_blog.git'
set :deploy_to, '/home/eneifert/webapps'

set :app_path, -> { fetch(:env_app_path) }
set :full_app_path, -> { "#{deploy_to}/#{fetch(:env_app_path)}" }

role :web, "eneifert@web491.webfaction.com"
role :app, "eneifert@web491.webfaction.com"
role :db,  "eneifert@web491.webfaction.com", :primary => true 

namespace :webfaction do 

	task :deploy do 
		on roles(:app) do			
			[{dir: "josiahs_blog", env: "production"}].each do |item|
				tmp_deploy_to = "#{deploy_to}/#{item[:dir]}"
				tmp_full_app_path = "#{tmp_deploy_to}/Josiahs_blog"

				# set up the path variables
				env_var_cmd = "cd #{tmp_deploy_to} && export PATH=$PWD/bin:$PATH && export GEM_HOME=$PWD/gems && export RUBYLIB=$PWD/lib &&"	      	      

				# pull the code and get rid of any changes						
				execute "cd #{tmp_full_app_path} && git config --global user.email \"josiahrachaelbenji@gmail.com\""
				execute "cd #{tmp_full_app_path} && git config --global user.name \"Josiah\""
				execute "cd #{tmp_full_app_path} && git stash save --keep-index"
				execute "cd #{tmp_full_app_path} && git stash drop"
				execute "cd #{tmp_full_app_path} && git pull #{repo_url}"

				# update the gems
				execute "#{env_var_cmd} cd #{tmp_full_app_path} && bundle install"

				# migrate the db
				execute "#{env_var_cmd} cd #{tmp_full_app_path} && rake db:migrate RAILS_ENV=#{item[:env]}"
				execute "#{env_var_cmd} cd #{tmp_full_app_path} && rake db:seed RAILS_ENV=#{item[:env]}"				

				# #udpate cron tasks
				# execute "#{env_var_cmd} cd #{tmp_full_app_path} && bundle exec whenever --set 'environment=#{item[:env]} & path=#{item[:dir]}' --update-crontab"

				# bundle the assets
				execute "#{env_var_cmd} cd #{tmp_full_app_path} && RAILS_ENV=#{item[:env]} bundle exec rake assets:precompile"

				# restart the server
				execute "$HOME/webapps/#{item[:dir]}/nginx/sbin/nginx -p $HOME/webapps/#{item[:dir]}/nginx/ -s reload"

			end
	    end		
	end

end

namespace :deploy do

  puts "============================================="
  puts "SIT BACK AND RELAX WHILE CAPISTRANO ROCKS ON!"
  puts "============================================="

end

