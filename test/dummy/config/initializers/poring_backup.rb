
# run backup `rake poring_backup:perform`

PoringBackup.config 'PiYa Server' do

  # before do |logger|
  #   #do somethings before backup
  # end

  # after do |logger|
  #   #do somethings after backup
  # end

  database :PostgreSQL do
    database 'onebox_core_development'
    username 'Mac'
    # password 'password'
  end

  store_with :S3 do
    access_key_id 'AKIAJOO6YDGD6K7MDIVA'
    secret_access_key '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'
    bucket 'oneboxcore-dev'
    region 'ap-southeast-1'
    path 'backups'
  end

  notifier :Slack do
    webhook "https://hooks.slack.com/services/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"
    channel "#test_slack_web_api"
    only_env [:development, :production]
  end

end