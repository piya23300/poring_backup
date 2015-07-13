module PoringBackup
  module Databases
    class PostgreSQL < Database

      def initialize setting, &block
        @db_name = nil
        @host = 'localhost'
        @port = nil
        @username = nil
        @password = nil

        instance_eval(&block) if block_given?
        @file = "#{db_name}.pgsql"
        super
      end

      def backup
        PoringBackup.logger.info "PostgreSQL backup processing"
        super
        begin
          system db_dump
          PoringBackup.logger.info "#{' '*18}success"
        rescue => e
          PoringBackup.logger.warn "#{' '*18}failed!"
          PoringBackup.logger.debug "#{' '*18}tmp_file: #{tmp_file_path}"
          PoringBackup.logger.debug "#{' '*18}errors => #{e}"
        end
        PoringBackup.logger.info "#{' '*18}finished"
      end

      def restore
        #psql -U {user-name} -d {desintation_db} -f {dumpfilename.sql}
        #psql -U <username> -d <dbname> -1 -f <filename>.sql
        #pg_restore -U <username> -d <dbname> -1 -f <filename>.dump
      end

      def database name
        @db_name = name
      end

      def host name
        @host = name
      end

      def port number
        @port = number
      end

      def username name
        @username = name
      end

      def password password=nil
        @password = password
      end

      def db_dump
        "sudo " +
        "#{password_option}" +
        "pg_dump #{connection_options} #{general_options} #{db_name}"
      end

      def notify_message
        @notify_message ||= db_name
      end

      private
        def connection_options
          options = ''
          options << "--host=#{@host || 'localhost'}"
          options << " --port=#{@port}" if @port
          options << " --username=#{@username}" if @username
          options
        end

        def password_option
          "PGPASSWORD=#{ Shellwords.escape(@password) } " if @password
        end

        def general_options
          options = ''
          options << "--file=#{tmp_file_path}"
          options << ' --compress=9'
          options
        end
    end
  end
  
end
