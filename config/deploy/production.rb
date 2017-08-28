server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], roles: %w(web app db)
set :branch, 'production'

set :docker_volumes, [
  "#{shared_path}/log:/var/www/app/log",
  "props_production_assets:/var/www/app/public/assets",
]

set :docker_links, %w(postgres_ambassador:postgres redis_ambassador:redis)
set :docker_additional_options, -> { "--env-file #{shared_path}/envfile" }
set :docker_dockerfile, "docker/production/Dockerfile"

set :docker_apparmor_profile, "docker-ptrace"
set :docker_cpu_quota, "200000"
