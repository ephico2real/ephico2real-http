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

       if $operatingsystemmajrelease <= 6 {
         exec { 'iptables':
           command => "iptables -I INPUT 1 -p tcp -m multiport --ports ${httpd_port} -m comment --comment 'Custom HTTP Web Host' -j ACCEPT && iptables-save > /etc/sysconfig/iptables",
           path => "/sbin",
           refreshonly => true,
           subscribe => Package['httpd'],
         } 
         service { 'iptables':
           ensure => running,
           enable => true,
           hasrestart => true,
           subscribe => Exec['iptables'],
        }
      }   
      elsif $operatingsystemmajrelease == 7 {
         exec { 'firewall-cmd':
           command => "firewall-cmd --zone=public --addport=${httpd_port}/tcp --permanent",
           path => "/usr/bin/",
           refreshonly => true,
           subscribe => Package['httpd'],
         }
         service { 'firewalld':
           ensure => running,
           enable => true,
           hasrestart => true,
           subscribe => Exec['firewall-cmd'],
         }
     }
}

