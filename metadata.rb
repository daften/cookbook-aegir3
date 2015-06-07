name             'aegir3'
maintainer       'Picabit'
maintainer_email 'info@picabit.be'
license          'Apache 2.0'
description      'Hosting System for Drupal Sites'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
recipe           "aegir3", "Install aegir with the chosen method (default: package)"
recipe           "aegir3::package", "Install aegir from package"
recipe           "aegir3::script", "Install aegir with nginx and php-fpm"
recipe           "aegir3::mysql_secure", "Secure mysql installation"
recipe           "aegir3::extensions", "Install extensions based on attributes"
recipe           "aegir3::ssh_keygen", "Generate DSA key pair for the aegir user"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "chef-sugar"
depends "apt"
depends "php"
depends "mysql", "< 6.0.0"
depends "mysql_tuning"
