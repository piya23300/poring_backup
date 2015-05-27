module PoringBackup
  class Notifier

    attr_reader :setting
    attr_reader :notify_message

    def initialize setting, &block
      @setting = setting
    end

    def notify!
    end

    def notify_message
      @notify_message ||= :Sender
    end

    private
      def on_disabled
        :disabled
      end
      def on_success
        :success
      end
      def on_failure error_message
        error_message
      end

      def storages_list
        setting.storages.map { |s| "[#{s.class.name.demodulize}] #{s.notify_message}" }.join("\n")
      end

      def databases_list
        setting.databases.map { |db| "[#{db.class.name.demodulize}] #{db.notify_message}" }.join("\n")
      end

      def notifiers_list
        setting.notifiers.map { |notify| "[#{notify.class.name.demodulize}] #{notify.notify_message}" }.join("\n")
      end

  end
end 
