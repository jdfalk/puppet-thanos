# thanos::query
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::query
class thanos::query (
    String  $log_level                     = 'info',
    String  $gcloudtrace_project           = '',
    String  $gcloudtrace_sample_factor     = 0,
    String  $grpc_port                     = 12901,
    String  $grpc_address                  = "0.0.0.0:${grpc_port}",
    String  $grpc_advertise_address        = '',
    String  $http_port                     = 12902,
    String  $http_address                  = "0.0.0.0:${http_port}",
    String  $cluster_port                  = 12900,
    String  $cluster_address               = "0.0.0.0:${cluster_port}",
    String  $cluster_advertise_address     = '',
    Array   $cluster_peers                 = [],
    String  $cluster_gossip_interval       = '5s',
    String  $cluster_pushpull_interval     = '5s',
    String  $query_timeout                 = '2m',
    String  $query_max_concurrent          = 20,
    String  $query_replica_label           = 'prometheus_replica',
    Array   $selector_label                = [],
    Array   $store                         = [],
) {
  include thanos::install
  systemd::unit_file { 'thanos-query.service':
  content => "
### Managed by Puppet ###
[Unit]
Description=Prometheus Thanos Subsystem
Wants=basic.target
After=basic.target network.target

[Service]
ExecStart=/usr/bin/thanos query \\
  --cluster.peers prometheus1.bco.tym.cudaops.com:10900 \\
  --cluster.peers prometheus.cudaops.com:10900 \\
  --cluster.peers prometheusstorage0.bco.tym.cudaops.com:10900 \\
  --cluster.peers prometheus0.bco.tor.cudaops.com:10900 \\
  --query.replica-label=${query_replica_label} \\
  --log.level=${log_level}
Restart=always

[Install]
WantedBy=multi-user.target",

  } ~> service {'thanos-query':
  ensure => 'running',
  enable => true,
}

  # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::thanos::query gossip':
    dest_port => $cluster_port,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }

  # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::thanos::query thanos grpc':
    dest_port => $grpc_port,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }

    # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::thanos::query thanos http':
    dest_port => $http_port,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }


}
