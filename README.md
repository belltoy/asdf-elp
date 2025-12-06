<div align="center">

# asdf-elp [![Build](https://github.com/belltoy/asdf-elp/actions/workflows/build.yml/badge.svg)](https://github.com/belltoy/asdf-elp/actions/workflows/build.yml) [![Lint](https://github.com/belltoy/asdf-elp/actions/workflows/lint.yml/badge.svg)](https://github.com/belltoy/asdf-elp/actions/workflows/lint.yml)

</div>

[elp](https://whatsapp.github.io/erlang-language-platform) plugin for the [asdf version manager](https://asdf-vm.com).

- [Summary](#summary)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

## Summary

Since `elp` use date as release version for now, this plugin provides aliases for each supported
OTP version for conveniently installing the latest `elp` for that OTP version. For developers who
work with multiple OTP versions, this plugin can help to easily switch between different `elp`
versions by specific `elp` OTP version in the `.tool-versions` file. For example:

```
elp otp-26
elp otp-27
elp otp-28
```

## Dependencies

- `bash`, `curl`, `tar`, `jq`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

## Install

Plugin:

```shell
asdf plugin add elp
# or
asdf plugin add elp https://github.com/belltoy/asdf-elp.git
```

elp:

```bash
# Show all installable versions
asdf list all elp

# Install specific version, from the list all above
asdf install elp otp-27.3-2025-11-04

# Install specific OTP version (recommended)
# This will install the latest elp version for OTP 27
asdf install elp otp-27

# Set a version globally (on your ~/.tool-versions file)
asdf set -u elp otp-27

# Now elp commands are available
elp version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

## Contributing

Contributions of any kind welcome!

## References

If you use [mise](https://mise.jdx.dev/), you can use [mise-elp](https://github.com/belltoy/mise-elp)
plugin to manage `elp` versions in your projects.

## License

See [LICENSE](LICENSE) © [Zhongqiu Zhao](https://github.com/belltoy/)
