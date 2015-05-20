
require 'aws-sdk'
require 'logging'

require 'poring_backup/setting'
require 'poring_backup/logger'

require 'poring_backup/database'
require 'poring_backup/databases/postgresql'

require 'poring_backup/storage'
require 'poring_backup/storages/s3'

# tasks
require "poring_backup/railtie" if defined?(Rails)

module PoringBackup
  class << self
    attr_reader :model
    def config &block
      @model = Setting.new(&block)
    end
  end
end
