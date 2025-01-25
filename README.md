# Vehicle-Tracking-System
This project simulates a Vehicle tracking system by streaming data from multiple sources like vehicles, GPS systems, traffic cameras, weather stations, and emergency incidents. The project is designed to ingest, process, and store data in a cloud-based ecosystem using Apache Kafka, Apache Spark, Amazon S3, AWS Glue, and Amazon Redshift.

The project aims to showcase how to handle real-time data pipelines in the cloud, with detailed data storage and processing steps in Amazon S3, AWS Glue Cataloging, and Amazon Redshift integration.



## 📋 Prerequisites

Before running the project, ensure you have the following:
-  Docker: To containerize and run the project.
-  AWS Account: For setting up Amazon S3, AWS Glue, and Redshift.
-  Apache Kafka: To stream data.
-  Apache Spark: For data processing.
-  IAM Roles (see below for details): Required to grant the project proper access to AWS resources.


## 🗂️ Files in the Repository
-  main.py: Python script to simulate and push data to Kafka topics.
-  docker-compose.yml: Docker configuration for running Kafka and other dependencies.
-  dataProcessing_spark.py: Apache Spark script to process and store Kafka streams in S3.
-  requirements.txt: Python dependencies for the project.
-  redshift-query.sql: SQL queries for querying data stored in Redshift.


## 🚀 Setup
1. Clone the Repository:

```bash
   git clone https://github.com/Vikneshwar-GK/Vehicle-Tracking-System.git
   cd Vehicle-Tracking-System
```
2. Docker Setup:<br/>
   To run Kafka locally, the project uses Docker and Docker Compose. Ensure Docker is installed and running on your machine.

```bash
   docker-compose up -d
```
This will start up the necessary services, including Apache Kafka. The data will be streamed from Kafka topics in real-time (simulated).

3. Install Python Dependencies: <br/>
   Install the required Python libraries for the project.

   ```bash
   pip install -r requirements.txt
   ```

4. AWS Setup: <br/>
   Make sure you have an AWS account set up and access keys generated. Add your AWS credentials in the config.py file:

   ```Python
   configuration = {
    "AWS_ACCESS_KEY": "__YOUR_AWS_ACCESS_KEY__",
    "AWS_SECRET_KEY": "__YOUR_AWS_SECRET_KEY__"
   }
   ```

## 🛡️ IAM Roles and Permissions

Proper IAM roles and permissions are essential for securely accessing and interacting with the AWS services used in this project. Below are the required IAM roles:

1. IAM Role for Apache Spark (S3 Access): <br/>
   This role grants Spark permission to write data to Amazon S3. You will use this role when configuring your Spark job to interact with S3.

Permissions:
-  s3:PutObject
-  s3:GetObject
-  s3:ListBucket
-  s3:DeleteObject

Example IAM Role Policy:

``` json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name/*",
        "arn:aws:s3:::your-bucket-name"
      ]
    }
  ]
}
```

2. IAM Role for AWS Glue (S3 and Glue Catalog Access):
   This IAM role allows AWS Glue to read from S3 and write the crawled data into the Glue Catalog.

Permissions:
-  s3:GetObject
-  s3:ListBucket
-  glue:CreateTable
-  glue:UpdateTable
-  glue:GetTable

Example IAM Role Policy:

``` json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "glue:CreateTable",
        "glue:UpdateTable",
        "glue:GetTable"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name/*",
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:glue:region:account-id:catalog",
        "arn:aws:glue:region:account-id:database/vehicletracking",
        "arn:aws:glue:region:account-id:table/vehicletracking/*"
      ]
    }
  ]
}
```

3. IAM Role for Amazon Redshift (S3 Access):
   This IAM role allows Amazon Redshift to access the data stored in S3 via Glue’s external schema and the Redshift Spectrum feature.

Permissions:
-  s3:GetObject
-  glue:GetTable

Example IAM Role Policy:

``` json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "glue:GetTable"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name/*",
        "arn:aws:glue:region:account-id:catalog",
        "arn:aws:glue:region:account-id:database/vehicletracking",
        "arn:aws:glue:region:account-id:table/vehicletracking/*"
      ]
    }
  ]
}
```
After creating the IAM roles, you can associate them with your AWS Glue, Amazon Redshift, and Spark jobs.
