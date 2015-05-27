require 'poring_backup/callback'

module PoringBackup
  class Setting
    include Settings::Callback

    attr_reader :before_actions, :after_actions
    attr_reader :dir, :tmp_dir
    attr_reader :databases, :storages, :notifiers
    attr_reader :created_at
    
    def initialize &block
      @created_at = Time.now.strftime("%Y.%m.%d.%H.%M.%S")
      @before_actions = []
      @after_actions = []
      @dir = 'poring_backups'
      @tmp_dir = "tmp/poring_backups"
      @databases = []
      @storages = []
      @notifiers = []
      instance_eval(&block) if block_given?
    end

    def database model, &block
      @databases << class_from_scope(Databases, model).new(self, &block)
    end

    def store_with model, &block
      @storages << class_from_scope(Storages, model).new(self, &block)
    end

    def notifier model, &block
      @notifiers << class_from_scope(Notifiers, model).new(self, &block)
    end

    def perform!
      PoringBackup.logger.info "PoringBackup Start..."
      before_backup
      backup!
      store!
      clear_tmp!
      after_backup
      notify!
      PoringBackup.logger.info "PoringBackup Done"
    end

    def clear_tmp!
      FileUtils.rm_rf(tmp_dir)
      PoringBackup.logger.debug "clear tmp directory"
    end

    private
      def class_from_scope scope, klass
        "#{scope}::#{klass}".constantize
      end

      def backup!
        PoringBackup.logger.info "--------- Backup ----------"
        databases.each(&:backup)
      end

      def store!
        PoringBackup.logger.info "----------- Store ---------"
        storages.each(&:upload)
      end

      def notify!
        PoringBackup.logger.info "----------- Notifier ---------"
        notifiers.each(&:notify!)
      end

     
      
  end
end
