# thanos::install
#
# Install's Thanos
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::install
class thanos::install (
  String $version = 'v0.1.0_rc.1',
) {
  package { 'thanos':
      ensure  => $version,
    }
}
