module PoringBackup
  module Notifiers
    class Slack < Notifier

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
        @webhook = url
      end

      def channel name
        @channel = name
      end

      def only_env envs=[]
        @envs = envs.map(&:to_s)
      end

      def notify!
        return unless envs.include?(Rails.env) or envs.empty?

        options = {
          :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
          :body     => URI.encode_www_form(:payload => JSON.dump(data))
        }
                # options.merge!(:expects => 200) # raise error if unsuccessful
        Excon.post(uri, options)
      end

      private
        def envs
          @envs ||= []
        end

        def uri
          @uri ||= @webhook  
        end

        def data
          @data = {
            :channel  => @channel,
            :username => 'Poring Backup',
            :icon_emoji => ":ghost:",
            :attachments => [
              {
                :fallback   => "New ticket from Andrea Lee - Ticket #1943: Can't rest my password - https://groove.hq/path/to/ticket/1943",
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
                    :title => "Storages",
                    :value => storages_list,
                    :short => false
                  },
                  {
                    :title => "Databases",
                    :value => databases_list,
                    :short => false
                  }
                ]
              }
            ]
          }
        end

        def storages_list
          setting.storages.map { |s| "[#{s.class.name.demodulize}] #{s.notify_text}" }.join("\n")
        end

        def databases_list
          setting.databases.map { |db| "[#{db.class.name.demodulize}] #{db.db_name}" }.join("\n")
        end

      

    end
  end
end
