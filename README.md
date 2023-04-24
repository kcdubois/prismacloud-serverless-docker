# Prisma Cloud - Serverless Defender with Docker

This repository contains example files for the Prisma Cloud Serverless Defender deployment option with container images
instead of the embedded or layer.

### Generating TW_POLICY variable
To get the Base64 string required for TW_POLICY, use the following endpoints to generate a token, then encode the 
function parameters.

```shell
# Retrieve token
curl -X POST https://<compute-api>/<customer_id>/api/v1/authenticate \
-d '{ "username": $PRISMA_ACCESS_KEY, "password": $PRISMA_SECRET_KEY }'
```

```shell
# Console address is the app.ca corresponding Compute instance
curl -X POST https://<compute-api>/<customer_id>/api/v1/policies/runtime/serverless/encode \
-H 'Authorization: Bearer $COMPUTE_TOKEN' \
-d '{
    "consoleAddr": "northamerica-northeast1.cloud.twistlock.com", 
    "provider": "aws",
    "function": $LAMBDA_FUNCTION_NAME
}'
```

### Build base container image
Using the `docker` folder of this repository, you can build a base image from one of the AWS base image and embed the 
Prisma Cloud Defender code into it. 
* Download the `twistlock_defender_layer.zip` from the `Compute > Manage > Defender > Manual Deploy` page as if you were
installing it manually.
* Unzip the folder as `twistlock` in the `docker` directory. The folder should contain a `python` and `twistlock` 
folder.
* Build the base image. The `twistlock` python module will become the handler called from Lambda, and will chain the
real handler using the `ORIGINAL_HANDLER` variable.

### Build function container image
From the base image you created in the previous section, you can now add your function code like the example in 
the `function` folder. Do not modify the CMD handler.