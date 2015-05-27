require "rails_helper"


module PoringBackup
  module Notifiers
    describe Slack do
      let(:setting) {
        PoringBackup.config('My Brand') do

          # before do |logger|
          #   #do somethings before backup
          # end

          # after do |logger|
          #   #do somethings after backup
          # end
          database :PostgreSQL do
            database 'database_name_2'
            username 'username'
            password 'password'
          end

          database :PostgreSQL do
            database 'database_name_1'
            username 'username'
            password 'password'
          end

          store_with :S3 do
            access_key_id 'access_key_id'
            secret_access_key 'secret_access_key'
            bucket 'bucket_name'
            region 'region'
            path 'your/path'
          end

          notifier :Slack do
            webhook "https://slack.webhook.uri"
            channel "#channel_name"
            # only_env [:development, :production]
          end

        end
        @setting = PoringBackup.model
      }
      let(:slack) {
        @slack = PoringBackup::Notifiers::Slack.new(PoringBackup::Setting.new) do
          webhook 'https://slack.webhook.uri'
          channel '#channel_name'
          only_env [:development, :production]
        end
      }
      context "initialize" do
        
        it "webhook_uri" do
          expect(slack.webhook_uri).to eq 'https://slack.webhook.uri'
        end
        it "channel_name" do
          expect(slack.channel_name).to eq '#channel_name'
        end
        it "on_envs" do
          expect(slack.on_envs).to eq(["development", "production"])
        end
      end
      context "#notify!" do
        it "return :disabled if env does not in on_envs" do
          slack.only_env [:woring_env]
          expect(slack.notify!).to eq :disabled
        end
        it "return :success if env work" do
          slack.only_env []
          Excon.stub({}, {:body => 'ok', :status => 200})
          expect(slack.notify!).to eq :success
        end
        it "return errors if failure" do
          slack.only_env []
          error_message = 'failed : Invalid channel specified'
          Excon.stub({}, {:body => error_message, :status => 500})
          expect(slack.notify!).to eq error_message
        end
      end
      it "#data" do
        slack = setting.notifiers.first
        data = slack.send :data
        expect_data = {
          :channel=>"#channel_name", 
          :username=>"Poring Backup", 
          :icon_emoji=>":ghost:", 
          :attachments=>[
            {
              :fallback=>"more information at <https://github.com/piya23300/poring_backup|poring_backup gem>", 
              :pretext=>"backup at #{setting.created_at}", 
              :title=> "My Brand",
              :color=>"#7CD197", 
              :fields=>[
                {
                  :title=>"Environment", 
                  :value=>"test", 
                  :short=>true
                },
                {
                  :title=>"Contect", 
                  :value=>"<https://github.com/piya23300/poring_backup|poring_backup gem>", 
                  :short=>true
                },
                {
                  :title=>"Databases", 
                  :value=>"[PostgreSQL] database_name_2\n[PostgreSQL] database_name_1",
                  :short=>false
                },
                {
                  :title=>"Storages", 
                  :value=>"[S3] bucket: bucket_name, path: your/path", 
                  :short=>false
                },
                {
                  :title=>"Notifier", 
                  :value=>"[Slack] Sender", 
                  :short=>false
                }
              ]
            }
          ]
        }
        expect(data).to eq expect_data
      end
    end
  end
end
