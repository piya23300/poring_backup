require "rails_helper"

module PoringBackup
  describe Setting do
    it "initialize" do
      setting = PoringBackup::Setting.new
      expect(setting.tmp_dir).to eq 'tmp/poring_backups'
      expect(setting.dir).to eq 'poring_backups'
      expect(setting.databases).to eq []
      expect(setting.storages).to eq []
      expect(setting.created_at).not_to eq nil
    end
    it "generate database object" do
        setting = PoringBackup::Setting.new do
            database :PostgreSQL do
              database 'onebox_core_development'
              username 'postgres'
              password '1234'
            end
          end
        expect(setting.databases.size).to eq 1  
        expect(setting.databases.first).to be_a(Databases::PostgreSQL)  
    end
    it "generate storages object" do
        setting = PoringBackup::Setting.new do
            store_with :S3 do
              access_key_id 'AKIAJOO6YDGD6K7MDIVA'
              secret_access_key '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'
              bucket 'oneboxcore-dev'
              region 'ap-southeast-1'
              path 'backups'
            end
          end
        expect(setting.storages.size).to eq 1  
        expect(setting.storages.first).to be_a(Storages::S3)  
    end
    it "generate notifier object" do
        setting = PoringBackup::Setting.new do
            notifier :Slack do
              webhook 'https://slack.webhook.uri'
              channel '#channel_name'
              only_env [:development, :production]
            end
          end
        expect(setting.notifiers.size).to eq 1  
        expect(setting.notifiers.first).to be_a(Notifiers::Slack)  
    end
    it "#clear_tmp! will delete tmp directory" do
      setting = PoringBackup::Setting.new
      FileUtils.mkdir_p(setting.tmp_dir)
      expect(File.exists?(setting.tmp_dir)).to eq true
      setting.clear_tmp!
      expect(File.exists?(setting.tmp_dir)).to eq false
    end
    it "#before_action to do somethings" do
      setting = PoringBackup::Setting.new do
        before do |logger|
          logger.info 'test before backup'
        end
      end
      expect(setting.before_actions.size).to eq 1
    end
    it "#after_action to do somethings" do
      setting = PoringBackup::Setting.new do
        after do |logger|
          logger.info 'test after backup'
        end
      end
      expect(setting.after_actions.size).to eq 1
    end

  end
end
