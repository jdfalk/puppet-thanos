# thanos::query
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @param $log_level           [String] Optional      
#   Log filtering level.
# @param $gcloudtrace_project [String] Optional
#   GCP project to send Google Cloud Trace tracings to. 
#   If empty, tracing will be disabled.
# @param $gcloudtrace_sample_factor [String] Optional
#   How often we send traces (1/<sample_factor>).  
#   If 0 no trace will be sent periodically, unless forced by baggage item. 
#   See `pkg/tracing/tracing.go` for details.
# @param $grpc_port [String] Required
#   Listen port for gRPC endpoints (StoreAPI).
# @oaram $grpc_address [String] Required
#   Listen ip address for gRPC endpoints (StoreAPI). 
#   Make sure this address is routable from other components if you use gossip, 
#   'grpc_advertise_address' is empty and you require cross_node connection.
# @param $grpc_advertise_address [String] optional
#   Explicit (external) host:port address to advertise for gRPC StoreAPI in gossip cluster. 
#   If empty, 'grpc_address' will be used.
# @param $http_port [String] Required
#   Listen port for HTTP endpoints.
# @param $http_address [String] optional
#   Listen host for HTTP endpoints.
# @param $cluster_port [String] Required
#   Listen port for gossip cluster.
# @oaram $cluster_address [String] optional
#   Listen ip address for gossip cluster.
# @param $cluster_advertise_address [String]
#   Explicit (external) ip:port address to advertise for gossip in gossip cluster. 
#   Used internally for membership only
# @param $cluster_peers [Array][String] required
#   Initial peers to join the cluster. It can be either <ip:port>, or <domain:port>. 
#   A lookup resolution is done only at the startup.
# @param $cluster_gossip_interval [String] optional
#   Interval between sending gossip messages. 
#   By lowering this value (more frequent) gossip messages are propagated across 
#   the cluster more quickly at the expense of increased bandwidth.
# @param $cluster_pushpull_interval [String] optional
#   Interval for gossip state syncs. Setting this interval lower (more frequent)
#   will increase convergence speeds across larger clusters at the expense of 
#   increased bandwidth usage.
# @example
#   include thanos::query
class thanos::query (
    String  $log_level                     = 'info',
    String  $gcloudtrace_project           = '',
    Integer $gcloudtrace_sample_factor     = 0,
    Integer $grpc_port                     = 11901,
    String  $grpc_address                  = "0.0.0.0:${grpc_port}",
    String  $grpc_advertise_address        = '',
    Integer $http_port                     = 11902,
    String  $http_address                  = "0.0.0.0:${http_port}",
    Integer $cluster_port                  = 11900,
    String  $cluster_address               = "0.0.0.0:${cluster_port}",
    String  $cluster_advertise_address     = '',
    Array   $cluster_peers                 = [],
    String  $cluster_gossip_interval       = '5s',
    String  $cluster_pushpull_interval     = '5s',
    String  $query_timeout                 = '2m',
    Integer $query_max_concurrent          = 20,
    String  $query_replica_label           = 'prometheus_replica',
    Array   $selector_label                = [],
    Array   $store                         = [],
) {
  include systemd
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
