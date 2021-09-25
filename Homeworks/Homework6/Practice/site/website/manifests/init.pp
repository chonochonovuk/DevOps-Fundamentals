class website {

  exec {'apt-update':
    command => '/usr/bin/sudo /usr/bin/apt-get update'
  }

  package { 'php':
    ensure => installed,
    require => Exec['apt-update']
  }

  package { 'apache2':
    ensure => present,
    require => Package['php']
  }

  package { 'php-mysqlnd':
    ensure => installed,
  }

  service { 'apache2':
    ensure => running,
    enable => true,
    require => Package['php']
  }

  file { "/var/www/html/index.html":
    ensure => absent,
 }

  # Get the index.php file from puppet and place it in the document root
  file { "/var/www/html/index.php":
    ensure => file,
    source => 'puppet:///modules/website/index.php',
 }

 # Get the bulgaria-map.png file from puppet and place it in the document root
  file { "/var/www/html/bulgaria-map.png":
    ensure => file,
    source => 'puppet:///modules/website/bulgaria-map.png',
    notify  => Service['apache2']
 }

}