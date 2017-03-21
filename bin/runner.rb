require './lib/teki'

key = ARGV[0]
secret = ARGV[1]
region = 'ap-northeast-1'
path = ARGV[2]
dry_run = ARGV[3] ? true : false
::Teki.setup(key: key, secret: secret, region: region, config_path: path, dry_run: dry_run)
