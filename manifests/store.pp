# thanos::store
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
# @param $data_dir [String] optional
#   Data directory.
# @param $gcs_bucket [String] optional
#   Google Cloud Storage bucket name for stored blocks. 
#   If empty sidecar won't store any block inside Google Cloud Storage.
# @param $s3_bucket [String]
#   S3_Compatible API bucket name for stored blocks.
# @param $s3_endpoint [String] optional
#   S3_Compatible API endpoint for stored blocks.
# @param $s3_access_key [String] optional
#   Access key for an S3_Compatible API.
# @param $s3_insecure [String] optional
#   Whether to use an insecure connection with an S3_Compatible API.
# @param $s3_signature_version2 [String] optional
#   Whether to use S3 Signature Version 2; otherwise Signature Version 4 will be used.
# @param $s3_encrypt_sse [String] optional
#   Whether to use Server Side Encryption
# @param $index_cache_size [String] optional 
#   Maximum size of items held in the index cache.
#   Default: 250MB
# @param $chunk_pool_size [String] optional
#   Maximum size of concurrently allocatable bytes for chunks.
#   Default: 2GB
#
# @example
#   include thanos::store
class thanos::store (
    String  $log_level                            = 'info',
    Optional[String]  $gcloudtrace_project        = undef,
    Integer $gcloudtrace_sample_factor            = 0,
    Integer $grpc_port                            = 12901,
    String  $grpc_address                         = "0.0.0.0:${grpc_port}",
    Optional[String]  $grpc_advertise_address     = undef,
    Integer $http_port                            = 12902,
    String  $http_address                         = "0.0.0.0:${http_port}",
    Integer $cluster_port                         = 12900,
    String  $cluster_address                      = "0.0.0.0:${cluster_port}",
    Optional[String]  $cluster_advertise_address  = undef,
    Array   $cluster_peers                        = [],
    Optional[String]  $cluster_gossip_interval    = undef,
    Optional[String]  $cluster_pushpull_interval  = undef,
    Optional[String]  $cluster_refresh_interval   = undef,
    Optional[String]  $cluster_secret_key         = undef,
    String  $cluster_network_type                 = 'wan',
    String  $data_dir                            = '/var/lib/thanos/store',
    Optional[String]  $gcs_bucket                 = undef,
    String  $s3_bucket                            = 'prometheus',
    Optional[String]  $s3_endpoint                = undef,
    Optional[String]  $s3_access_key              = undef,
    Optional[String]  $s3_secret_key              = undef,
    Optional[Boolean] $s3_insecure                = false,
    Optional[Boolean] $s3_signature_version2      = false,
    Optional[Boolean] $s3_encrypt_sse             = false,
    Optional[String]  $index_cache_size           = undef,
    Optional[String]  $chunk_pool_size            = undef,
    Optional[String]  $store_objstore_config_file = '/etc/thanos/store_bucket.yaml',
    Boolean $cluster_enable                       = false,
    Optional[String] $store_grpc_series_max_concurrency = '20',
    Optional[String] $store_grpc_series_sample_limit = undef,
) {
  include systemd
  include thanos
  include thanos::install

  if $store_objstore_config_file {
    file { $store_objstore_config_file:
      ensure  => present,
      group   => $thanos::group,
      mode    => '0750',
      owner   => $thanos::user,
      content => template('thanos/bucket.yaml.erb'),
    }
  }

  systemd::unit_file { 'thanos-store.service':
  content => template('thanos/thanos-store.service.erb'),

  } ~> service {'thanos-store':
  ensure => 'running',
  enable => true,
  }

}
