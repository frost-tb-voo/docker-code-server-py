#FROM codercom/code-server:1.939
FROM codercom/code-server:latest
MAINTAINER Novs Yama

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/docker-code-server-py"

USER root
WORKDIR /python
RUN apt-get -qq update \
 && apt-get -qq -y install npm \
 && apt-get -q -y autoclean \
 && apt-get -q -y autoremove \
 && rm -rf /var/lib/apt/lists \
 && npm install -g n --silent \
 && npm cache clean --force -g \
 && rm -rf ~/.npm \
 && n 10
ENV VSCODE_PYTHON_VERSION=2019.6.24221
RUN apt-get -qq update \
 && apt-get -qq -y install curl zip unzip \
 && curl -L -o ms-python-release.vsix https://github.com/microsoft/vscode-python/releases/download/${VSCODE_PYTHON_VERSION}/ms-python-release.vsix \
 && unzip -q ms-python-release.vsix \
 && rm ms-python-release.vsix \
 && cd /python/extension \
 && npm install \
 && npm audit fix --force \
 && npm cache clean --force \
 && rm -r node_modules package-lock.json \
 && npm install \
 && npm cache clean --force \
 && rm -rf ~/.npm \
 && cd /python \
 && zip -q -r ms-python-release.vsix . \
 && apt-get -q -y purge curl zip unzip \
 && apt-get -q -y autoclean \
 && apt-get -q -y autoremove \
 && rm -rf /var/lib/apt/lists \
 && rm -r /python/extension

WORKDIR /home/coder/project
USER coder
RUN code-server --install-extension /python/ms-python-release.vsix

USER root
ADD settings.json /home/coder/.local/share/code-server/User/settings.json
RUN cd / \
 && rm -r /python \
 && chown -hR coder /home/coder

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8
RUN apt-get -y update \
 && apt-get -y install python3 python3-pip python3-venv exuberant-ctags \
 && apt-get -y autoclean \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists
 && cd /usr/local/bin \
 && ln -s /usr/bin/idle3 idle \
 && ln -s /usr/bin/pydoc3 pydoc \
 && ln -s /usr/bin/python3 python \
 && ln -s /usr/bin/python3-config python-config \
 && ln -s /usr/bin/pip3 pip

USER coder
ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8
RUN python -m pip install rope pytest nose pyspark \
    pyformat isort flake8 pycodestyle
