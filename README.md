# wercker-bitbucket-upload

A wercker bitbucket uploader written in `bash` and `curl`.

[![wercker status](https://app.wercker.com/status/a468e950a4e0f97cf28f1eaad652c513/m "wercker status")](https://app.wercker.com/project/bykey/a468e950a4e0f97cf28f1eaad652c513)

# Options

- `key` OAuth key
- `secret` OAuth secret
- `file` filename path
- 'git_owner: "AVTopchiy"
              git_repository: "km-cib-stubs"

OAuth needs a key and secret, together these are know as an OAuth consumer. You can create a consumer on any existing individual or team account. 

# Example

```yaml
build:
    steps:
        - phantomx/bitbucket-upload-artifact@0.0.1:
            key: g25sMaaBypPR4QccyH
            secret: dh87Krw9bwSFHMdr2mvw552LqNJdq
            file: war/out.jar
            git_owner: phantomx
            git_repository: bitbucket-upload
```

# License

The MIT License (MIT)

# Changelog

## 0.0.1

- Initial release
