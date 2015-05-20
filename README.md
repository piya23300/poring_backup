[![Build Status](https://travis-ci.org/piya23300/poring_backup.svg)](https://travis-ci.org/piya23300/poring_backup)

# PoringBackup

This gem work with rails 4.2.1 up.

**Databases support**

- PostgreSQL

**Storeages support**

- S3

## Installing

`rake poring_backup:install`

to generate `config/initilizers/poring_backup.rb for setting

## Setting

at `/config/initilizers/poring_backup.rb`

```
PoringBackup.config do

  before do |logger|
    #do somethings before backup
  end

  after do |logger|
    #do somethings after backup
  end

  database :PostgreSQL do
    database 'database_name'
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

end
```

## Usage

`rake poring_backup:perform`

to run backup


***

This project rocks and uses MIT-LICENSE.
