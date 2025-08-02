# DEPRECATION NOTICE

## ⚠️ This module is deprecated

This Puppet module (`jdfalk/thanos`) is **DEPRECATED** and is no longer maintained.

## ✅ Use this instead

Please use **[maeq/thanos](https://forge.puppet.com/maeq/thanos)** which provides:

- 🔄 **Active maintenance** - regularly updated with latest Thanos versions
- 🏗️ **Complete functionality** - supports all Thanos components (sidecar, query, store, compact, rule, receive, etc.)
- 🌟 **Modern standards** - current Puppet SDK, dependencies, and best practices
- 📦 **Proper installation** - downloads Thanos releases directly from GitHub
- 📚 **Great documentation** - comprehensive README with examples
- 👥 **Active community** - 18 forks and ongoing contributions

## Migration

Replace your existing usage:

```puppet
# OLD (deprecated)
include thanos
```

With the recommended module:

```puppet
# NEW (recommended)
class { 'thanos':
  version => '0.26.0'
}
```

## Why was this deprecated?

This module was created as a basic PDK scaffold but was never developed into a functional module. The installation approach assumed a 'thanos' package would be available in system package repositories, which is not how Thanos is distributed.

Rather than rebuild functionality that already exists in a well-maintained module, this deprecation redirects users to the superior alternative.

## Links

- **Recommended Module on Puppet Forge**: https://forge.puppet.com/maeq/thanos
- **Source Code**: https://github.com/syberalexis/puppet-thanos
- **Documentation**: https://github.com/syberalexis/puppet-thanos/blob/master/README.md