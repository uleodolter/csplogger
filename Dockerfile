FROM alpine:3.12

RUN apk add --no-cache \
	python3 \
	sqlite \
	libffi-dev \
	musl-dev \
	py3-pip \
	python3-dev \
	gcc \
	openssl-dev \
	git \
	curl \
	&& apk del libressl-dev \
	&& rm -rf /var/cache/apk/*

RUN adduser -D csplogger-agent

COPY --chown=csplogger-agent:csplogger-agent [ "requirements.txt", "/app/" ]
RUN pip install -r /app/requirements.txt

COPY --chown=csplogger-agent:csplogger-agent [ ".", "/app/" ]

EXPOSE 8080
USER csplogger-agent
WORKDIR /app
ENV FLASK_APP app.py
HEALTHCHECK --interval=50s --timeout=3s --start-period=5s CMD curl -f http://localhost:8080/ || exit 1
CMD [ "gunicorn", "--bind", "0.0.0.0:8080", "app:app" ]
