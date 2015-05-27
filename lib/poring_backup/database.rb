module PoringBackup
  class Database

    attr_reader :setting
    attr_reader :file, :tmp_file_path, :file_path
    attr_reader :path, :tmp_dir, :file_dir
    attr_reader :created_at
    attr_reader :db_name
    attr_reader :notify_message

    def initialize setting, &block
      @created_at = setting.created_at
      @setting = setting
      @path ||= 'db_backups'
      @file ||= 'db_backup.sql'
      
      gen_file_dir
      gen_file_path
      gen_tmp_dir
      gen_tmp_file_path
    end

    def backup
      FileUtils.mkdir_p(tmp_dir)
    end

    def clear_tmp!
      FileUtils.rm_rf(tmp_file_path)
    end

    private
      def gen_file_dir
        @file_dir = "#{path}/#{created_at}"
      end
      def gen_file_path
        @file_path = "#{file_dir}/#{file}"
      end

      def gen_tmp_dir
        @tmp_dir = "#{setting.tmp_dir}/#{file_dir}"
      end
      def gen_tmp_file_path
        @tmp_file_path ||= "#{tmp_dir}/#{file}"
      end
  end
end
