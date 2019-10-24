# docker-code-server-py
[![](https://img.shields.io/travis/frost-tb-voo/docker-code-server-py/master.svg?style=flat-square)](https://travis-ci.org/frost-tb-voo/docker-code-server-py/)
[![GitHub stars](https://img.shields.io/github/stars/frost-tb-voo/docker-code-server-py.svg?style=flat-square)](https://github.com/frost-tb-voo/docker-code-server-py/stargazers)
[![GitHub license](https://img.shields.io/github/license/frost-tb-voo/docker-code-server-py.svg?style=flat-square)](https://github.com/frost-tb-voo/docker-code-server-py/blob/master/LICENSE)
[![Docker pulls](https://img.shields.io/docker/pulls/novsyama/code-server-py.svg?style=flat-square)](https://hub.docker.com/r/novsyama/code-server-py)
[![Docker image-size](https://img.shields.io/microbadger/image-size/novsyama/code-server-py.svg?style=flat-square)](https://microbadger.com/images/novsyama/code-server-py)
![Docker layers](https://img.shields.io/microbadger/layers/novsyama/code-server-py.svg?style=flat-square)

An unofficial extended VSCode [code-server](https://github.com/cdr/code-server) image for latest python3 with [vscode-python](https://github.com/microsoft/vscode-python/releases).
See [novsyama/code-server-py](https://hub.docker.com/r/novsyama/code-server-py/)

## How

```bash
PROJECT_DIR=<workspace absolute path>

sudo docker pull novsyama/code-server-py
sudo docker run --name=vscode --net=host -d \
 -v "${PROJECT_DIR}:/home/coder/project" \
 -w /home/coder/project \
 --security-opt "seccomp:unconfined" \
 novsyama/code-server-py \
 code-server \
 --allow-http --no-auth
```

And open http://localhost:8443 with your favorites browser.
For detail options, see [code-server](https://github.com/cdr/code-server).

### Pathes of vscode code-server
If you want to preserve the settings and extensions, please mount following pathes with `-v` option of `docker run` command.

- Home : /home/coder
- Extension path : ~/.local/share/code-server/extensions
- Settings path : ~/.local/share/code-server/User/settings.json
  - or, ${PROJECT_DIR}/.vscode/settings.json

