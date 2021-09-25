class dockersite {

  exec {'apt-update':
    command => '/usr/bin/sudo /usr/bin/apt-get update'
  }

  Exec["apt-update"] -> Package <| |>
  
  package { 'apt-transport-https':
    ensure => installed,
    require => Exec['apt-update']
  }

  package { 'curl':
    ensure => installed,
    require => Exec['apt-update']
  }
  
  package { 'gnupg':
    ensure => installed,
    require => Exec['apt-update']
  }
  
  package { 'lsb-release':
    ensure => installed,
    require => Exec['apt-update']
  }
  
  exec {'curl-command':
    command => '/usr/bin/sudo /usr/bin/curl -fsSL https://download.docker.com/linux/ubuntu/gpg | /usr/bin/sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg',
    require => Package['curl']
  }
  
  exec {'echo-command':
    command => '/usr/bin/echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | /usr/bin/sudo tee /etc/apt/sources.list.d/docker.list > /dev/null',
    require => Exec['apt-update']
  }
  
  
   package { 'docker-ce':
    ensure => installed,
    require => Exec['apt-update']
  }
  
  
   package { 'docker-ce-cli':
    ensure => installed,
    require => Exec['apt-update']
  }
  
   package { 'containerd.io':
    ensure => installed,
    require => Exec['apt-update']
  }
  
  
  exec {'enable-docker':
    command => '/usr/bin/sudo systemctl enable docker',
    require => Exec['apt-update']
  }
  
  exec {'start-docker':
    command => '/usr/bin/sudo systemctl start docker',
    require => Exec['apt-update']
  }
  
  exec {'usermod-docker':
    command => '/usr/sbin/usermod -aG docker vagrant',
    require => Exec['apt-update']
  }
  
}
