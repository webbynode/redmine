# webby_config for Redmine
# Requires:
# 	ruby 1.8.6, 1.8.7
# 	rails 2.2.2
# 	mysql 4.1 or higher / or PostgreSQL 8
# Optional Requires:  
# 	RMagick for Gantt export to png image.
# 	Ruby OpenID Library to enable OpenID support.
# 	SCM binaries for repository browsing (i.e. Git, SVN, CVS) must be available in PATH.

sudo gem install rails --version=2.2.2 --no-rdoc --no-ri

echo WC_DB_ENGINE=${WC_DB_ENGINE}
 
echo "
login: &login
  adapter: ${WC_DB_ENGINE}
  database: ${WC_APP_NAME}
  username: ${WC_APP_NAME}
  password: ${WC_DB_PASSWORD}
  host: localhost
" > config/database.yml
 
if [ "${WC_DB_ENGINE}" == "mysql" ]; then
echo "
production:
  <<: *login
  encoding: utf8
" >> config/database.yml
fi
 
if [ "${WC_DB_ENGINE}" == "postgresql" ]; then
echo "
production:
  <<: *login
  encoding: unicode
  pool: 5
  port: 5432
" >> config/database.yml
fi

rake config/initializers/session_store.rb
rake db:migrate RAILS_ENV=production
rake redmine:load_default_data RAILS_ENV=production << EOF
en
EOF

chown www-data log
chown www-data files
chown www-data tmp
chown www-data public/plugin_assets

