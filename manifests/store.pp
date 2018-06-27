# thanos::store
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::store
class thanos::store (
    String  $log_level                 = 'info',
    String  $gcloudtrace_project       = '',
    String  $gcloudtrace_sample_factor = 0,
    String  $grpc_address              = '0.0.0.0:10901',
    String  $grpc_advertise_address    = '',
    String  $http_address              = '0.0.0.0:10902',
    String  $cluster_address           = '0.0.0.0:10900',
    String  $cluster_advertise_address = '',
    Array   $cluster_peers             = [],
    String  $cluster_gossip_interval   = '5s',
    String  $cluster_pushpull_interval = '5s',
    String  $tsdb_path                 = '/var/data/prometheus',
    String  $gcs_bucket                = '',
    String  $s3_bucket                 = 'prometheus',
    String  $s3_endpoint               = '',
    String  $s3_access_key             = '',
    String  $s3_secret_key             = '',
    String  $s3_insecure               = '',
    String  $s3_signature_version2     = '',
    String  $s3_encrypt_sse            = '',
    String  $index_cache_size          = '250MB',
    String  $chunk_pool_size           = '2GB',
) {

    package { 'thanos':
      ensure  => latest,
    }

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
  --log.level=debug
Restart=always

[Install]
WantedBy=multi-user.target",

  } ~> service {'thanos':
  ensure => 'running',
  enable => true,
}

  # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::prometheus::server thanos gossip':
    dest_port => 10900,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }

  # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::prometheus::server thanos grpc':
    dest_port => 10901,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }

    # Open up the thanos ports
  ::functions::firewall_rule { '100 profiles::prometheus::server thanos http':
    dest_port => 10902,
    ipset     => 'entire_internal_cloud',
    options   => {
      iniface => $::facts['interfaces_private'][0]
    }
  }

}
