require "rails_helper"

module PoringBackup
  describe Database do
    include FakeFS::SpecHelpers
    let(:db) {
      allow_any_instance_of(Time).to receive(:strftime).and_return("date_time_dir")
      @db = Database.new(Setting.new)
    }
    context "initialize" do
      it "setting" do
        expect(db.setting).to be_a(Setting) 
      end
      it "backup path" do
        expect(db.path).to eq 'db_backups' 
      end
      it "backup file name" do
        expect(db.file).to eq 'db_backup.psql' 
      end
      it "backup file dir" do
        expect(db.file_dir).to eq 'db_backups/date_time_dir' 
      end
      it "backup file path" do
        expect(db.file_path).to eq 'db_backups/date_time_dir/db_backup.psql' 
      end
      it "backup tmp dir" do
        expect(db.tmp_dir).to eq 'tmp/poring_backups/db_backups/date_time_dir' 
      end
      it "backup tmp file path" do
        expect(db.tmp_file_path).to eq 'tmp/poring_backups/db_backups/date_time_dir/db_backup.psql' 
      end
    end

    it "#backup will create tmp directory" do
      db.backup
      expect(File.exists?(db.tmp_dir)).to eq true
    end

    it "#clear_tmp! will delete tmp directory" do
      FileUtils.mkdir_p(db.tmp_file_path)
      expect(File.exists?(db.tmp_file_path)).to eq true
      db.clear_tmp!
      expect(File.exists?(db.tmp_file_path)).to eq false
    end
  end
end
