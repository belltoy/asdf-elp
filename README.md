<div align="center">

# asdf-elp [![Build](https://github.com/belltoy/asdf-elp/actions/workflows/build.yml/badge.svg)](https://github.com/belltoy/asdf-elp/actions/workflows/build.yml) [![Lint](https://github.com/belltoy/asdf-elp/actions/workflows/lint.yml/badge.svg)](https://github.com/belltoy/asdf-elp/actions/workflows/lint.yml)

</div>

[elp](https://whatsapp.github.io/erlang-language-platform) plugin for the [asdf version manager](https://asdf-vm.com).

> [!Tip]
> Since `elp` use date as release version for now, this plugin provides aliases for each supported
> OTP version for conveniently installing the latest `elp` for that OTP version.

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, `jq`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add elp
# or
asdf plugin add elp https://github.com/belltoy/asdf-elp.git
```

elp:

```shell
# Show all installable versions
asdf list all elp

# Install specific version
asdf install elp latest

# Set a version globally (on your ~/.tool-versions file)
asdf global elp latest

# Now elp commands are available
elp version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/belltoy/asdf-elp/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Zhongqiu Zhao](https://github.com/belltoy/)
