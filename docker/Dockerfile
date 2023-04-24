FROM public.ecr.aws/lambda/python:3.8

# Copy twistlock code
COPY ./twistlock/python/twistlock ./twistlock
COPY ./twistlock/twistlock/libtw_serverless.so ${LAMBDA_TASK_ROOT}/twistlock/

ENV TW_POLICY=""
ENV ORIGINAL_HANDLER="lambda_handler.handler"

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "twistlock.handler" ]