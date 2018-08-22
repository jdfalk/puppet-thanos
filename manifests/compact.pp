# thanos::compact
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::compact
class thanos::compact(
  String  $log_level                       = 'info',
  Optional[String]  $gcloudtrace_project   = undef,
  Integer $gcloudtrace_sample_factor       = 0,
  Integer $http_port                       = 13902,
  String  $http_address                    = "0.0.0.0:${http_port}",
  String  $data_dir                        = '/var/data/thanos-compact',
  Optional[String]  $gcs_bucket            = undef,
  String  $s3_bucket                       = 'prometheus',
  Optional[String]  $s3_endpoint           = undef,
  Optional[String]  $s3_access_key         = undef,
  Optional[String]  $s3_secret_key         = undef,
  Optional[Boolean] $s3_insecure           = undef,
  Optional[String]  $s3_signature_version2 = undef,
  Optional[String]  $s3_encrypt_sse        = undef,
  String  $sync_delay                      = '30m',
  Boolean $wait                            = true,
) {
  include systemd
  include thanos
  include thanos::install

  file { $data_dir:
      ensure => directory,
      owner  => $thanos::user,
      group  => $thanos::group,
      mode   => '0664',
    }


  systemd::unit_file { 'thanos-compact.service':
  content => template('thanos/thanos-compact.service.erb'),

  } ~> service {'thanos-compact':
  ensure => 'running',
  enable => true,
}




}
