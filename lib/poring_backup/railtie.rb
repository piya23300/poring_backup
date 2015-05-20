require 'poring_backup'
require 'rails'

module PoringBackup
  class Railtie < Rails::Railtie
    rake_tasks do
      import File.expand_path('../../tasks/poring_backup_tasks.task', __FILE__)
    end
  end
end