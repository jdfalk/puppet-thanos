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
  Integer $http_port                     = 11982,
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
  include thanos::install

  if $wait{
    $wait_param = '--wait'
  }

  systemd::unit_file { 'thanos-compactor.service':
  content => "
### Managed by Puppet ###
[Unit]
Description=Prometheus Thanos Compactor Subsystem
Wants=basic.target
After=basic.target network.target

[Service]
ExecStart=/usr/bin/thanos compactor \\
  --log.level=${log_level} \\
  --gcloudtrace.project=${gcloudtrace_project} \\
  --gcloudtrace.sample-factor=${gcloudtrace_sample_factor} \\
  --http-address=${http_address} \\
  --data-dir=${data_dir} \\
  --gcs.bucket=${gcs_bucket} \\
  --s3.bucket=${s3_bucket} \\
  --s3.endpoint=${s3_endpoint} \\
  --s3.access-key=${s3_access_key} \\
  --sync-delay=${sync_delay} \\
  ${wait_param}

Restart=always

[Install]
WantedBy=multi-user.target",

  } ~> service {'thanos-compactor':
  ensure => 'running',
  enable => true,
}




}
