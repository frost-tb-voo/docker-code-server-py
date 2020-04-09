ARG VSCODE_PYTHON_VERSION=2019.6.24221

FROM node as extension
ARG VSCODE_PYTHON_VERSION

WORKDIR /python
RUN apt-get -qq update \
 && apt-get -qq -y install curl unzip zip \
 && curl -L -o ms-python-release.vsix https://github.com/microsoft/vscode-python/releases/download/${VSCODE_PYTHON_VERSION}/ms-python-release.vsix \
 && unzip -q ms-python-release.vsix \
 && rm ms-python-release.vsix \
 && npm install -g n --silent \
 && n 10
WORKDIR /python/extension
RUN npm install --silent \
 && npm audit fix --force \
 && npm cache clean --force \
 && rm -rf node_modules package-lock.json \
 && npm install --silent \
 && npm cache clean --force \
 && n rm stable \
 && npm uninstall -g n --silent \
 && npm cache clean -g --force \
 && rm -rf ~/.npm \
 && cd /python \
 && zip -q -r ms-python-release.vsix .

FROM codercom/code-server
ARG VCS_REF
ARG VSCODE_PYTHON_VERSION

LABEL maintainer="Novs Yama"
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/docker-code-server-py"

USER root
ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8
RUN apt-get -qq -y update \
 && apt-get -qq -y install python3 python3-pip python3-venv exuberant-ctags \
 && apt-get -q -y autoclean \
 && apt-get -q -y autoremove \
 && rm -rf /var/lib/apt/ \
 && cd /usr/local/bin \
 && ln -s /usr/bin/idle3 idle \
 && ln -s /usr/bin/pydoc3 pydoc \
 && ln -s /usr/bin/python3 python \
 && ln -s /usr/bin/python3-config python-config \
 && ln -s /usr/bin/pip3 pip

ADD settings.json /home/coder/.local/share/code-server/User/settings.json
ADD settings.json /home/coder/.local/share/code-server/Machine
ADD settings.json /home/coder/project/.vscode/settings.json
COPY --from=extension /python/ms-python-release.vsix /home/coder/
RUN chown -hR coder /home/coder

USER coder
ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8
RUN python -m pip install --no-cache-dir \
    rope pytest nose pyspark \
    pyformat isort flake8 pycodestyle

WORKDIR /home/coder/project
RUN code-server --install-extension /home/coder/ms-python-release.vsix
