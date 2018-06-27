# thanos::sidecar
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::sidecar
class thanos::sidecar (
    String  $log_level                     = 'info',
    String  $gcloudtrace_project           = '',
    String  $gcloudtrace_sample_factor     = 0,
    String  $grpc_port                     = 10901,
    String  $grpc_address                  = "0.0.0.0:${grpc_port}",
    String  $grpc_advertise_address        = '',
    String  $http_port                     = 10902,
    String  $http_address                  = "0.0.0.0:${http_port}",
    String  $cluster_port                  = 10900,
    String  $cluster_address               = "0.0.0.0:${cluster_port}",
    String  $cluster_advertise_address     = '',
    Array   $cluster_peers                 = [],
    String  $cluster_gossip_interval       = '5s',
    String  $cluster_pushpull_interval     = '5s',
    String  $prometheus_url                = 'http://localhost:9090',
    String  $tsdb_path                     = '/var/data/prometheus',
    String  $gcs_bucket                    = '',
    String  $s3_bucket                     = 'prometheus',
    String  $s3_endpoint                   = '',
    String  $s3_access_key                 = '',
    String  $s3_secret_key                 = '',
    String  $s3_insecure                   = '',
    String  $s3_signature_version2         = '',
    String  $s3_encrypt_sse                = '',
    String  $reloader_config_file          = '',
    String  $reloader_config_envsubst_file = '',
    String  $reloader_rule_dir             = '',

) {
  include thanos::install
  systemd::unit_file { 'thanos.service':
  content => "
### Managed by Puppet ###
[Unit]
Description=Prometheus Thanos Subsystem
Wants=basic.target
After=basic.target network.target

[Service]
Environment=\'S3_SECRET_KEY=${s3_secret_key}\'
ExecStart=/usr/bin/thanos sidecar \\
  --tsdb.path=${tsdb_path} \\
  --cluster.peers prometheus1.bco.tym.cudaops.com:10900 \\
  --cluster.peers prometheus.cudaops.com:10900 \\
  --cluster.peers prometheusstorage0.bco.tym.cudaops.com:10900 \\
  --cluster.peers prometheus0.bco.tor.cudaops.com:10900 \\
  --s3.endpoint prometheusstorage1.bco.tym.cudaops.com:9000 \\
  --s3.bucket ${s3_bucket} \\
  --s3.access-key ${s3_access_key} \\
  --s3.insecure \\
  --log.level=${log_level}
Restart=always

[Install]
WantedBy=multi-user.target",

  } ~> service {'thanos':
  ensure => 'running',
  enable => true,
}

  # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::thanos::sidecar gossip':
    dest_port => $cluster_port,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }

  # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::thanos::sidecar grpc':
    dest_port => $grpc_port,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }

    # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::thanos::sidecar http':
    dest_port => $http_port,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }


}
