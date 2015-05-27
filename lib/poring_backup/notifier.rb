module PoringBackup
  class Notifier

    attr_reader :setting

    def initialize setting, &block
      @setting = setting
    end

    def notify!
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

  end
end 
