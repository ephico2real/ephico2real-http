# == Class: http::install
class http::install inherits http {
        package { 'httpd':
          ensure => 'present',
        }
        file { '/var/www/html/index.html':
          source => 'puppet:///modules/http/myfile',
          mode   => '0644',
          require => Package['httpd'],
        }
        service {'httpd':
          enable => 'true',
          ensure => 'true',
          require => Package['httpd'],
        }
}

