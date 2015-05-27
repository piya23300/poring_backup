module PoringBackup
  module Storages
    class S3 < Storage
      
      attr_reader :s3, :bucket_object

        def initialize setting, &block
          super
          instance_eval(&block) if block_given?
        end

        def s3
          @s3 ||= aws_resource
        end

        def bucket_object
          @bucket_object ||= s3.bucket(@bucket)
        end

        def access_key_id key
          @access_key_id = key
        end

        def secret_access_key key
          @secret_access_key = key
        end

        def bucket name
          @bucket = name
        end

        def region name
          @region = name
        end

        def path name
          @path = name
        end

        def upload
          PoringBackup.logger.info "S3 processing"
          setting.databases.each do |db|
            s3_path = "#{@path}/#{db.file_path}"
            object = bucket_object.object(s3_path)
            success = object.upload_file(db.tmp_file_path)
            if success
              PoringBackup.logger.info "#{' '*3}uploaded: #{s3_path}"
            else
              PoringBackup.logger.warn "#{' '*3}uploaded failure: #{db.tmp_file_path}"
            end
          end
          PoringBackup.logger.info "#{' '*3}finished"
        end

        def notify_text
          @notify_text ||= "bucket: #{@bucket}, path: #{@path}"
        end

        private
          def aws_resource
            @aws_resource ||= Aws::S3::Resource.new(client: aws_client)
          end
          def aws_client
            @aws_client ||= Aws::S3::Client.new(
                              region: @region,
                              credentials: aws_credentials
                            )
          end

          def aws_credentials
            @aws_credentials ||= Aws::Credentials.new(@access_key_id, @secret_access_key)
          end

    end
  end
end