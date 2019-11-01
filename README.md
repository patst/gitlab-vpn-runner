# GitLab runner with VPN connection

The OpenVPN connection must be created before the runner can be registered at the GitLab instance because the GitLab instance is private and not reachable from the network where the runner is hosted.

OpenVPN is used for the vpn connection.

The open vpn config file must be mounted under `/config/vpn_config.ovpn` and the username password combination in a text file named `/config/pass.txt` in separate lines.

The script execution is blocked until the GitLab url specified with `GITLAB_URL` env variable is reachable.

The runner config `toml` file can be mounted as a file: `/runner-config.toml` (see https://docs.gitlab.com/runner/register/index.html#runners-configuration-template-file )

## Configuration

| ENV VAR Name | Description |
|:-------------|:------------|
| NO_PROXY      | no proxy hosts |
| HTTP_PROXY      | proxy settings |
| HTTPS_PROXY      | proxy settings|
| VPN_CONFIG    | Filename where the OpenVPN config is mounted. Default: `/config/vpn_config.ovpn` |
| GITLAB_URL    | GitLab instance url with `https://` prefix  |
| REGISTRATION_TOKEN | Runner registration token    |
| TAGS   | Tags for the runner, e.g. `test,test2` |
| ADDITIONAL_REGISTRATION_PARAMS   | Parameters for the runner `register` command, e.g. `--tag-list "test"` |

Example run command: (all env vars are already exported and the current directory contains a `vpn_config.ovpn` and optional `runner-config.toml` file)

```
docker run --cap-add=NET_ADMIN \
    -e ADDITIONAL_REGISTRATION_PARAMS \
    -e REGISTRATION_TOKEN \
    -e GITLAB_URL \
    -v $PWD:/config \
    patst/gitlab-vpn-runner:latest
```
