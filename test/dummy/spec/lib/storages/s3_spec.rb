require "rails_helper"


module PoringBackup
  module Storages
    describe S3 do
      let(:aws) { 
        @aws = S3.new(Setting.new) do
          access_key_id 'new_access_key_id'
          secret_access_key 'new_secret_access_key'
          bucket 'new_bucket'
          region 'ap-southeast-1'
          path 'new/path'
        end
      }
      context "block" do
        it 'sets access_key_id' do
          expect(aws.instance_variable_get(:@access_key_id)).to eq 'new_access_key_id' 
        end
        it 'sets secret_access_key' do
          expect(aws.instance_variable_get(:@secret_access_key)).to eq 'new_secret_access_key' 
        end
        it 'sets bucket' do
          expect(aws.instance_variable_get(:@bucket)).to eq 'new_bucket' 
        end
        it 'sets region' do
          expect(aws.instance_variable_get(:@region)).to eq 'ap-southeast-1' 
        end
        it 'sets path' do
          expect(aws.instance_variable_get(:@path)).to eq 'new/path' 
        end
      end

      it "initialize" do
        expect(aws.s3).to be_an(Aws::S3::Resource)
        expect(aws.bucket_object).to be_an(Aws::S3::Bucket)
      end

      it "#upload"

    end
  end
end
