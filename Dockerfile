FROM python:3.12.8-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10000 -ms /bin/bash runner

WORKDIR /home/runner/app

COPY ./  ./

USER 10000
ENV PATH="${PATH}:/home/runner/.local/bin"

RUN pip install --no-cache-dir poetry==1.8.5 \
    && poetry install --only main

EXPOSE 8000

ENTRYPOINT [ "poetry", "run" ]
CMD [ "sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT" ]
