module PoringBackup
  module Notifiers
    class Slack < Notifier

      attr_reader :webhook_uri, :channel_name
      attr_reader :on_envs

      def initialize setting, &block
        super
        instance_eval(&block) if block_given?
      end

      # notifer :Slack do
      #   webhook 'url'
      #   channel '#channel'
      #   only_env [:development, :production]
      # end

      def webhook url
        @webhook_uri = url
      end

      def channel name
        @channel_name = name
      end

      def only_env envs=[]
        @on_envs = envs.map(&:to_s)
      end

      def notify!
        super
        return on_disabled unless on_envs.include?(Rails.env) or on_envs.empty?
        options = {
          :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
          :body     => URI.encode_www_form(:payload => JSON.dump(data))
        }
        # options.merge!(:expects => 200) # raise error if unsuccessful
        response = Excon.post(webhook_uri, options)
        @notify_message = if (response.data[:body] == 'ok')
                    PoringBackup.logger.info "Slack notify : #{on_success}"
                    on_success
                  else
                    PoringBackup.logger.warn "Slack notify : #{on_failure(response.data[:body])}"
                    on_failure(response.data[:body])
                  end
      end

      def on_envs
        @on_envs ||= []
      end

      private
        def data
          @data = {
            :channel  => channel_name,
            :username => 'Poring Backup',
            :icon_emoji => ":ghost:",
            :attachments => [
              {
                :fallback   => "more information at <https://github.com/piya23300/poring_backup|poring_backup gem>",
                :pretext    => "backup at #{setting.created_at}",
                # :title      => "Ticket #1943: Can't reset my password",
                # :title_link => "https://groove.hq/path/to/ticket/1943",
                # :text       => "Help! I tried to reset my password but nothing happened!",
                :color      => "#7CD197",
                :fields     => [
                  {
                    :title => "Environment",
                    :value => Rails.env,
                    :short => true
                  },
                  {
                    :title => "Contect",
                    :value => '<https://github.com/piya23300/poring_backup|poring_backup gem>',
                    :short => true
                  },
                  {
                    :title => "Databases",
                    :value => databases_list,
                    :short => false
                  },
                  {
                    :title => "Storages",
                    :value => storages_list,
                    :short => false
                  },
                  {
                    :title => "Notifier",
                    :value => notifiers_list,
                    :short => false
                  }
                ]
              }
            ]
          }
        end

        

    end
  end
end
