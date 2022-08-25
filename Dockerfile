#base image
FROM python:3.10.2-slim

# set working directory
WORKDIR /usr/src/app

ENV JOBS max

COPY sentinel ./sentinel
COPY poetry.lock ./
COPY pyproject.toml ./

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential \
    && pip install -U poetry \
    && poetry config virtualenvs.create false \
    && cd /usr/src/app \
    && poetry install --no-dev

ENV PYTHONPATH /usr/src/app

ENV PROJECT_NAME sentinel

ENV PORT 8000

# start app
CMD uvicorn sentinel.api:app \
      --host 0.0.0.0 \
      --port ${PORT} \
      --reload

# expose port for other services to connect to
EXPOSE ${PORT}

