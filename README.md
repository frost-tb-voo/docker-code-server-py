# docker-code-server-py
[![](https://img.shields.io/github/workflow/status/frost-tb-voo/docker-code-server-py/Docker?style=flat-square)](https://github.com/frost-tb-voo/docker-code-server-py/actions/workflows/docker-publish.yml)
[![GitHub stars](https://img.shields.io/github/stars/frost-tb-voo/docker-code-server-py.svg?style=flat-square)](https://github.com/frost-tb-voo/docker-code-server-py/stargazers)
[![GitHub license](https://img.shields.io/github/license/frost-tb-voo/docker-code-server-py.svg?style=flat-square)](https://github.com/frost-tb-voo/docker-code-server-py/blob/master/LICENSE)

An unofficial extended VSCode [code-server](https://github.com/cdr/code-server) image for latest python3 with [vscode-python](https://github.com/microsoft/vscode-python/releases).

## How

```bash
PROJECT_DIR=<workspace absolute path>

sudo docker pull ghcr.io/frost-tb-voo/code-server-py
sudo docker run --name=vscode --net=host -d \
 -v "${PROJECT_DIR}:/home/coder/project" \
 -w /home/coder/project \
 --security-opt "seccomp:unconfined" \
 novsyama/code-server-py \
 code-server \
 --auth none
```

And open http://localhost:8080 with your favorites browser.
For detail options, see [code-server](https://github.com/cdr/code-server).

### Pathes of vscode code-server
If you want to preserve the settings and extensions, please mount following pathes with `-v` option of `docker run` command.

- Home : /home/coder
- Extension path : ~/.local/share/code-server/extensions
- Settings path : ~/.local/share/code-server/User/settings.json
  - or, ${PROJECT_DIR}/.vscode/settings.json

### Install more extensions
- Download .vsix file from https://marketplace.visualstudio.com/.
- Put .vsix file into your project directory.
- Start the code-server container.
- Go to http://localhost:8080 and open the terminal and type
  - `code-server --install-extension $vsix_filepath`

## Similar official functionality in vscode
[Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)

This requires local installed visual studio code.

## Contact
Please open an issue:

https://github.com/frost-tb-voo/docker-code-server-py/issues

And mension to @frost-tb-voo.
