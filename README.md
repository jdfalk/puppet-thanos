# ⚠️ DEPRECATED - Use maeq/thanos instead

[![Build Status](https://travis-ci.org/jdfalk/puppet-thanos.svg?branch=master)](https://travis-ci.org/jdfalk/puppet-thanos)

## 🚨 This module is deprecated

**This module is no longer maintained and should not be used for new projects.**

## ✅ Recommended Alternative

Please use the **[maeq/thanos](https://forge.puppet.com/maeq/thanos)** module instead, which provides:

- ✅ **Actively maintained** (last updated June 2025)
- ✅ **Feature-complete** with all Thanos components supported
- ✅ **Modern Puppet SDK** and current dependencies
- ✅ **Proper installation method** (downloads from GitHub releases)
- ✅ **Comprehensive documentation** and examples
- ✅ **Active community** with regular updates

### Migration Guide

Replace this module with the recommended alternative:

```puppet
# Old (deprecated)
include thanos

# New (recommended)
class { 'thanos':
  version => '0.26.0'
}
```

### Links

- **Puppet Forge**: https://forge.puppet.com/maeq/thanos
- **GitHub Repository**: https://github.com/syberalexis/puppet-thanos
- **Documentation**: https://github.com/syberalexis/puppet-thanos/blob/master/README.md

---

## About This Repository

This module was originally created as a basic scaffold for managing Thanos with Puppet, but never developed into a fully functional module. The recommended alternative above provides all the functionality this module was intended to provide and much more.
