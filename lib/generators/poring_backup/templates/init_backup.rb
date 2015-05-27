
# run backup `rake poring_backup:perform`

PoringBackup.config('your service name') do

  # before do |logger|
  #   #do somethings before backup
  # end

  # after do |logger|
  #   #do somethings after backup
  # end

  # database :PostgreSQL do
  #   database 'database_name'
  #   username 'username'
  #   password 'password'
  # end

  # store_with :S3 do
  #   access_key_id 'access_key_id'
  #   secret_access_key 'secret_access_key'
  #   bucket 'bucket_name'
  #   region 'region'
  #   path 'your/path'
  # end

  # notifier :Slack do
  #   webhook "URL"
  #   channel "#channel"
  #   only_env [:development, :production]
  # end

end