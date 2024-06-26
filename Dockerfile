# References: using official Python images
# https://hub.docker.com/_/python
ARG OS
ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-${OS} as build-stage

ARG PIP_NO_CACHE_DIR=off
ARG PIP_DISABLE_PIP_VERSION_CHECK=on
ARG PIP_DEFAULT_TIMEOUT=100
ARG POETRY_VERSION

ENV POETRY_HOME=/opt/poetry

# https://python-poetry.org/docs/#installing-manually
RUN python -m venv ${POETRY_HOME}; \
    ${POETRY_HOME}/bin/pip install -U pip setuptools; \
    ${POETRY_HOME}/bin/pip install poetry==${POETRY_VERSION}

FROM python:${PYTHON_VERSION}-${OS} as production-image

ENV PATH="$PATH:/opt/poetry/bin" \
    DEBIAN_FRONTEND="noninteractive"

RUN set -ex \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
          curl \
          wget \
          gzip \
          unzip \
          zip \
          jq \
          tar \
    # pyenv suggested build environment
    && apt-get install -y --no-install-recommends \
          build-essential libssl-dev zlib1g-dev \
          libbz2-dev libreadline-dev libsqlite3-dev \
          libncursesw5-dev xz-utils tk-dev libxml2-dev \
          libxmlsec1-dev libffi-dev liblzma-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build-stage /opt/poetry /opt/poetry/
