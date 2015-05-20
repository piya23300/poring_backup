require 'rails/generators/base'

module PoringBackup
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer_file
        copy_file "init_backup.rb", "config/initializers/poring_backup.rb"
      end
    end
  end
end