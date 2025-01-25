# Vehicle-Tracking-System
This project simulates a Vehicle tracking system by streaming data from multiple sources like vehicles, GPS systems, traffic cameras, weather stations, and emergency incidents. The project is designed to ingest, process, and store data in a cloud-based ecosystem using Apache Kafka, Apache Spark, Amazon S3, AWS Glue, and Amazon Redshift.

The project aims to showcase how to handle real-time data pipelines in the cloud, with detailed data storage and processing steps in Amazon S3, AWS Glue Cataloging, and Amazon Redshift integration.

________________________________________________________________________________________________________________________________________________________________________________________________

📋 Prerequisites

Before running the project, ensure you have the following:
-  Docker: To containerize and run the project.
-  AWS Account: For setting up Amazon S3, AWS Glue, and Redshift.
-  Apache Kafka: To stream data.
-  Apache Spark: For data processing.
-  IAM Roles (see below for details): Required to grant the project proper access to AWS resources.

________________________________________________________________________________________________________________________________________________________________________________________________

🗂️ Files in the Repository
-  main.py: Python script to simulate and push data to Kafka topics.
-  docker-compose.yml: Docker configuration for running Kafka and other dependencies.
-  dataProcessing_spark.py: Apache Spark script to process and store Kafka streams in S3.
-  requirements.txt: Python dependencies for the project.
-  redshift-query.sql: SQL queries for querying data stored in Redshift.

________________________________________________________________________________________________________________________________________________________________________________________________

🚀 Setup
1. Clone the Repository

.  git clone https://github.com/Vikneshwar-GK/Vehicle-Tracking-System.git
.  cd smart-city-real-time-data
