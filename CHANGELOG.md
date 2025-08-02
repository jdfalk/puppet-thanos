# Changelog

All notable changes to this project will be documented in this file.

## Release 0.1.1 - DEPRECATED

**BREAKING CHANGES**

This module is now **DEPRECATED** and should not be used for new projects.

**Recommended Alternative**

Please migrate to the **[maeq/thanos](https://forge.puppet.com/maeq/thanos)** module which provides:
- Active maintenance and regular updates
- Complete Thanos component support
- Modern Puppet SDK and dependencies  
- Proper installation from GitHub releases
- Comprehensive documentation and examples

**Migration**

Replace `include thanos` with:
```puppet
class { 'thanos':
  version => '0.26.0'
}
```

## Release 0.1.0

**Features**

- Basic module scaffold created

**Known Issues**

- Module was never fully developed beyond basic scaffold
- Installation method assumes unavailable system packages
