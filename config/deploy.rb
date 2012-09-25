set :application, "trade_calc"
set :svn_user, 'mbeattie_beet'
set :svn_password, 'RxYO4mIeCsw4'
set :repository, Proc.new { "--username #{svn_user} " +
       "--password #{svn_password} " +
       "http://mbeattie.unfuddle.com/svn/mbeattie_tradingcalc/trunk" }
set :ssh_options, {:port => 2345}
set :user, "eurovin"
set :deploy_to, "/home/eurovin/trade_calc"
set :deploy_via, :remote_cache
set :use_sudo, false

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "122.100.15.234"
role :web, "122.100.15.234"
role :db,  "122.100.15.234", :primary => true

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/system #{release_path}/public/system"
  end
end

task :after_setup do
  run "mkdir #{shared_path}/system"
end
