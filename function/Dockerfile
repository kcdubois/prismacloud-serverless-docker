FROM kcdubois/lambda/python:3.8-twistlock

COPY lambda_handler.py ${LAMBDA_TASK_ROOT}/lambda_handler.py

CMD [ "twistlock.handler" ]