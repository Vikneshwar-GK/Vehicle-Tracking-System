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

<br/>

## 💡 Data Flow and Cloud Integration

This project utilizes Apache Kafka, Apache Spark, Amazon S3, AWS Glue, and Amazon Redshift for processing and querying real-time data. Below are the detailed steps for handling the data pipeline from S3 to Glue and Redshift:

### Step 1: Store Data in Amazon S3 (Using Apache Spark) <br/>
1.	Kafka to S3: The dataprocessing_spark.py file processes incoming data from Kafka topics (vehicle data, GPS data, traffic data, weather data, and emergency data) using Apache Spark. The processed data is then written to Amazon S3 in Parquet format.
2.	S3 Bucket Setup: Make sure to create an S3 bucket where the processed data will be stored. You can specify the bucket name and folder structure in the Spark configuration.
3.	Data Writing: In dataprocessing_spark.py, Spark reads data from Kafka, processes it, and stores it in the following S3 paths:
      -  Vehicle data: s3a://spark-streaming-data/data/vehicle_data
	   -  GPS data: s3a://spark-streaming-data/data/gps_data
	   -  Traffic data: s3a://spark-streaming-data/data/traffic_data
	   -  Weather data: s3a://spark-streaming-data/data/weather_data
	   -  Emergency data: s3a://spark-streaming-data/data/emergency_data
4. Parquet Format: Data is stored in Parquet format, which is an efficient format for analytics, providing benefits like columnar storage and compression.

### Step 2: Use AWS Glue Crawler to Crawl Data in S3 <br/>
1. Create a Glue Crawler: In AWS Glue, create a crawler to crawl the data stored in your S3 bucket.
   -  Go to the AWS Glue Console.
	-  Under Crawlers, click on Add Crawler.
	-  Define the S3 Path where the data is stored (e.g., s3://spark-streaming-data/data).
   -  Set up the crawler to output results to the Glue Data Catalog.
2.	Run the Crawler: After configuring the crawler, run it to scan the Parquet files in your S3 bucket and infer their schema. The crawler will automatically populate the Glue Data Catalog with tables corresponding to the different datasets (vehicle, GPS, traffic, weather, and emergency).

### Step 3: Catalog Data in AWS Glue <br/>
1. Glue Data Catalog: After running the crawler, AWS Glue will populate the Glue Data Catalog with metadata describing your data. The Glue Catalog is a central repository for all data and schema information that can be used by other AWS services like Amazon Redshift.
2. Verify Tables: In the Glue Console, go to Tables under Data Catalog to ensure the tables for each dataset (vehicle, GPS, traffic, weather, and emergency) are listed.

### Step 4: Query Data in Amazon Redshift <br/>
1. Set up Redshift Cluster: In AWS, create a Redshift cluster where you will query your data. Ensure that Redshift has an IAM role that allows access to your S3 bucket and Glue Catalog.
2. Create External Schema in Redshift: Use the following SQL query (in redshift-query.sql) to create an external schema in Redshift, linking it to the Glue Data Catalog:
   ```sql
   create external schema dev_vehicletracking
   from data catalog
   database vehicletracking
   iam_role 'arn:aws:I am::.....'
   region 'us-east-1';
   ```

3. Query Data: Once the external schema is set up, you can query data directly from S3 using SQL. For example, to query GPS data:
   ``` sql
   select * from dev_vehicletracking.gps_data;
   ```
   This query will fetch the data stored in S3, processed by Spark, and cataloged by Glue.

## 🏁 Running the Project

1. Start Kafka: Run Kafka locally using Docker: <br/>
``` bash
docker-compose up -d
```
2.	Run the Spark Streaming Job: Process data from Kafka and write to S3: <br/>
``` python
python dataProcessing_spark.py
```
3.	Trigger Glue Crawler: Run the Glue Crawler to catalog the data.
4.	Query Data in Redshift: Use Amazon Redshift’s external schema to query the data in S3.
