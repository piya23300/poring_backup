module PoringBackup
  class << self
    attr_reader :logger
  end
  module Logger
    class << self
      def log_file_path
        file_name = Rails.env.product? ? 'backup' : "backup_#{Rails.env}"
        "log/#{file_name}.log"
      end
    end

    Logging.color_scheme( 'bright',
      :levels => {
        :info  => :green,
        :warn  => :yellow,
        :error => :red,
        :fatal => [:white, :on_red]
      },
      :date => :blue,
      :logger => :cyan,
      :message => :magenta
    )

    Logging.appenders.stdout(
      'stdout',
      :layout => Logging.layouts.pattern(
        :pattern => '[%d] %-5l %c: %m\n',
        :color_scheme => 'bright'
      )
    )
    
    PoringBackup.instance_variable_set("@logger", Logging.logger['PoringBackup::Log'])
    PoringBackup.logger.add_appenders(
      Logging.appenders.stdout,
      Logging.appenders.file(:poring_backup,
        filename: log_file_path,
        # layout: Logging.layouts.pattern(
        #   :pattern => '[%d] %-5l : %m\n',
        #   :color_scheme => 'bright'
        # )
      )
    )
  end
end