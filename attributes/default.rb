default['aegir3']['install_method'] = 'package'
default['aegir3']['install_folder'] = '/var/aegir'

# Attributes needed for both install methods
default['aegir3']['frontend'] = 'localhost'
default['aegir3']['admin_email'] = 'webmaster@localhost'
default['aegir3']['webserver'] = 'apache2'

default['mysql_tuning']['tuning.cnf']['mysqld']['max_allowed_packet'] = '16M'

default['php']['conf_dir'] = '/etc/php5/apache2'
default['php']['directives'] = {
  'memory_limit' => '256M'
}
