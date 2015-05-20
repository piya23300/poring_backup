module PoringBackup
  module Settings
    module Callback

      def before &block
        @before_actions << block
      end

      def after &block
        @after_actions << block
      end

      private
         def before_backup
          unless @before_actions.empty?
            PoringBackup.logger.info "----- before processing..."
            @before_actions.each { |action| action.call(PoringBackup.logger) }
          end
        end

        def after_backup
          unless @after_actions.empty?
            PoringBackup.logger.info "----- after processing..."
            @after_actions.each { |action| action.call(PoringBackup.logger) }
          end
        end
    end
  end
end
