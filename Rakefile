#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Jqclient::Application.load_tasks


task :package do
  sha = `git rev-parse --verify HEAD`.chomp
  sh "git archive --format=zip HEAD > packages/contacts-#{sha[0..8]}.zip"
end