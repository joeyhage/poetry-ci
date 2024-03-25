# References: using official Python images
# https://hub.docker.com/_/python
ARG OS
ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-${OS} as build-stage
ARG POETRY_VERSION

ENV PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=${POETRY_VERSION} \
    POETRY_HOME=/opt/poetry

# https://python-poetry.org/docs/#installing-manually
RUN python -m venv ${POETRY_HOME}; \
    ${POETRY_HOME}/bin/pip install -U pip setuptools; \
    ${POETRY_HOME}/bin/pip install poetry==${POETRY_VERSION}

FROM python:${PYTHON_VERSION}-${OS} as production-image

ENV PATH="/opt/poetry/bin:$PATH"

COPY --from=build-stage /opt/poetry /opt/poetry/
