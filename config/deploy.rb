#require 'new_relic/recipes'
load 'deploy/assets'
set :application, "jqclient"
set :repository,  "git@github.com:fbvilela/jqclient.git"

set :scm, :git
set :user, "ec2-user"

task :production do 
  
  default_run_options[:pty] = true
  set :rails_env, "production"
  ssh_options[:user] = "ec2-user"
  ssh_options[:keys] = [File.join("~/.ssh/iproperty-sydney-ec2.pem")]
    
  role :web, "ec2-54-253-121-168.ap-southeast-2.compute.amazonaws.com"                          # Your HTTP server, Apache/etc
  role :app, "ec2-54-253-121-168.ap-southeast-2.compute.amazonaws.com"                          # This may be the same as your `Web` server
  role :db,  "ec2-54-253-121-168.ap-southeast-2.compute.amazonaws.com", :primary => true # This is where Rails migrations will run
  role :db,  "ec2-54-253-121-168.ap-southeast-2.compute.amazonaws.com"
  
  after 'deploy:finalize_update', 'deploy:bundle_install'
  after 'deploy:finalize_update', 'deploy:compile_assets'
  after 'deploy:finalize_update', 'deploy:restart'
  #after "deploy:finalize_update", "newrelic:notice_deployment"
end

task :staging do 
  puts "Deploying to staging is easy \n Just push it to Heroku with 'git push heroku master'"
  exit 0    
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
   end
   
   task :bundle_install do 
#     run "cd #{current_path} && bundle"
   end
   
   task :compile_assets do
     #run "cd #{current_path} && bundle exec rake assets:precompile"
   end
   
 end