require "rails_helper"

module PoringBackup
  module Databases
    describe PostgreSQL do
      let(:pg) { 
        @pg = PostgreSQL.new(Setting.new) do
          database 'new_database_name'
          host 'new_host_name'
          port 'new_port_name'
          username 'new_username_name'
          password 'new_password_name'
        end
      }
      context "block" do
        it 'sets db_name' do
          expect(pg.instance_variable_get(:@db_name)).to eq 'new_database_name' 
        end
        it 'sets host' do
          expect(pg.instance_variable_get(:@host)).to eq 'new_host_name' 
        end
        it 'sets port' do
          expect(pg.instance_variable_get(:@port)).to eq 'new_port_name' 
        end
        it 'sets username' do
          expect(pg.instance_variable_get(:@username)).to eq 'new_username_name' 
        end
        it 'sets password' do
          expect(pg.instance_variable_get(:@password)).to eq 'new_password_name' 
        end
      end

      context "#db_dump gets command for db dump" do
        it "full command" do
          dump_cmd = pg.db_dump
          expect_cmd = 'sudo'
          expect_cmd << ' PGPASSWORD=new_password_name'
          expect_cmd << ' pg_dump'
          expect_cmd << " --host=new_host_name"
          expect_cmd << " --port=new_port_name"
          expect_cmd << " --username=new_username_name"
          expect_cmd << " --file=#{pg.tmp_dir}/#{pg.file}"
          expect_cmd << " --compress=9"
          expect_cmd << " new_database_name"
          expect(dump_cmd).to eq expect_cmd
        end
        context "without" do
          it "host" do
            pg.host(nil)
            dump_cmd = pg.db_dump
            expect(dump_cmd).to match /--host=localhost/
          end
          it "port" do
            pg.port(nil)
            dump_cmd = pg.db_dump
            expect(dump_cmd).not_to match /--port/
          end
          it "username" do
            pg.username(nil)
            dump_cmd = pg.db_dump
            expect(dump_cmd).not_to match /--username/
          end
          it "password" do
            pg.password(nil)
            dump_cmd = pg.db_dump
            expect(dump_cmd).not_to match /PGPASSWORD=/
          end
        end
      end

      it "#backup create tmp db backup"# do
        # system 'pwd'
        # p File.exists?('texttttttt')
        # p FileUtils.mkdir_p('texttttttt')
        # p File.exists?('texttttttt')
        # pg.database 'onebox_core_development'
        # pg.host 'localhost'
        # pg.port nil
        # pg.username 'postgres'
        # pg.password '1234'
        # p pg.db_dump
        # p pg.tmp_directory
        # p FileUtils.mkdir_p(pg.tmp_directory)
        # p FileUtils.mkdir_p(pg.tmp_file_path)
        # p Dir.exists?(pg.tmp_directory)
        # p Dir.exists?(pg.tmp_file_path)
        # pg.backup
      #end

    end
  end
end
