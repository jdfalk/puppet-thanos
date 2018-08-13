# thanos::install
#
# Install's Thanos
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::install
class thanos::install (
  String $version = 'v1.0',
) {
  package { 'thanos':
      ensure  => $version,
    }
}
