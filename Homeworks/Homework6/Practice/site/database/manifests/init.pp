class database (
  $package_name = 'mariadb-server',
  $service_name = 'mariadb'
){
   exec {'apt-update':
    command => '/usr/bin/sudo /usr/bin/apt-get update'
  }
  
  package { $package_name:
    ensure => latest,
    require => Exec['apt-update']
  }

  service { $service_name:
  ensure => running,
  require => Package[$package_name]
}

file { 'bind':
    ensure => file,
    path   => '/etc/mysql/mariadb.conf.d/50-server.cnf',
    source => 'puppet:///modules/database/50-server.cnf',
    notify => Service[$service_name],
  }

 file { 'mysql_populate':
    ensure => file,
    path   => '/tmp/db_setup.sql',
    source => 'puppet:///modules/database/db_setup.sql',
  }

 exec { 'create_db':
    command  => '/usr/bin/sudo /usr/bin/mysql -u root < /tmp/db_setup.sql',
    require => [Package[$package_name], Service[$service_name]]
  }
}