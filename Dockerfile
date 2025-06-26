FROM python:3.12.8-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get install -y curl build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario sin privilegios
RUN useradd --uid 10000 -ms /bin/bash runner

# Crear carpeta de trabajo
WORKDIR /home/runner/app

# Copiar archivos antes de cambiar a USER
COPY pyproject.toml poetry.lock* ./

# Instalar Poetry y dependencias como root
RUN pip install --upgrade pip \
    && pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false \
    && poetry install --only main

# Copiar el resto del código
COPY . .
RUN chown -R runner:runner /home/runner



# Cambiar a usuario no root
USER 10000
ENV PATH="${PATH}:/home/runner/.local/bin"

EXPOSE 8000

ENTRYPOINT [ "poetry", "run" ]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
#CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT}
