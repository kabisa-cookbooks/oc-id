def read(file, default = '')
  IO.read(File.join(File.dirname(__FILE__), file)).strip
rescue Errno::ENOENT
  default
end

name             'oc-id'
maintainer       'Jean Mertz'
maintainer_email 'jean@mertz.fm'
license          'MIT'
description      'Installs and configures oc-id server'
long_description read('README.md')
version          read('VERSION', '0.1.0')

supports 'ubuntu'
supports 'debian'

depends 'apt',        '~> 2.6.0'
depends 'runit',      '~> 1.5.10'
depends 'artifact',   '~> 1.12.2'
depends 'rubies',     '~> 0.1.0'
depends 'nodejs',     '~> 2.1.0'
depends 'postgresql', '~> 3.4.2'
depends 'database',   '~> 2.3.0'
depends 'nginx',      '2.4.2'
