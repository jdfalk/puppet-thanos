# thanos::compactor
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::compactor
class thanos::compactor(
  String  $log_level                     = 'info',
  String  $gcloudtrace_project           = '',
  Integer $gcloudtrace_sample_factor     = 0,
  Integer $http_port                     = 13902,
  String  $http_address                  = "0.0.0.0:${http_port}",
  String  $data_dir                      = '/var/data/thanos-compactor',
  String  $gcs_bucket                    = '',
  String  $s3_bucket                     = 'prometheus',
  String  $s3_endpoint                   = '',
  String  $s3_access_key                 = '',
  String  $s3_secret_key                 = '',
  String  $s3_insecure                   = '',
  String  $s3_signature_version2         = '',
  String  $s3_encrypt_sse                = '',
  String  $sync_delay                    = '30m',
  Boolean $wait                          = true,
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


  systemd::unit_file { 'thanos-compactor.service':
  content => template('thanos-compactor.service.erb'),

  } ~> service {'thanos-compactor':
  ensure => 'running',
  enable => true,
}




}
