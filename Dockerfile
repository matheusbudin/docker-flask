FROM python:3.10

WORKDIR /usr/flask/application

RUN pip install flask

COPY ./app .

ENV FLASK_APP main.py
ENV FLASK_DEBUG 1
ENV FLASK_RUN_HOST 0.0.0.0

EXPOSE 5000

VOLUME [ "/usr/flask/application" ]
VOLUME [ "/usr/flask/application/logs"]

CMD [ "flask", "run" ]