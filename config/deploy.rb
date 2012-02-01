set :application, "jqclient"
set :repository,  "git@github.com:fbvilela/jqclient.git"

set :scm, :git
set :user, "fbvilela"
set :deploy_to, "/home/fbvilela/#{application}"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "208.113.248.63"                          # Your HTTP server, Apache/etc
role :app, "208.113.248.63"                          # This may be the same as your `Web` server
role :db,  "208.113.248.63", :primary => true # This is where Rails migrations will run
role :db,  "208.113.248.63"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end