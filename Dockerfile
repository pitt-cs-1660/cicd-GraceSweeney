# Builder code - stage 1?

#base image 
FROM python:3.11-buster AS builder

# set both to app 
WORKDIR /app

#copy before building 
COPY pyproject.toml poetry.lock /app/

# install poerrtry and upgrade pip in builder stage
RUN pip install --upgrade pip && pip install poetry

RUN poetry config virtualenvs.create false \
  && poetry install --no-root --no-interaction --no-ansi
  

# App code - stage 2
#base image 
FROM python:3.11-buster AS app

# set both to app 
WORKDIR /app

COPY --from=builder /app /app

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
