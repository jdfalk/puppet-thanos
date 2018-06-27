# thanos::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::install
class thanos::install (
  String $version = 'latest',
) {
  package { 'thanos':
      ensure  => $version,
    }
}
