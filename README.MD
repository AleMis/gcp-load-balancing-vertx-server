# `Setting HTTP Load Balancer for Managed Instance Group with Vertx HTTP Server in Google Cloud`

### `Description`
This project shows how to take advantage of benefits using Google Cloud Managed Instance Group for balancing traffic from Web to HTTP Server using HTTP Load Balancer.

### `Architecture`
HTTP Server was set up using Vert.X. SpringBoot was used to create stand-alone application. HTTP Server is not sophisticated, because it was not a purpose of this project. 

### `Prerequisites`
* Java 8
* Maven
* Docker
* Google Cloud CLI (gcloud) with Google Cloud account

Set up path described for Linux based OS. There is assumption that user of this scripts has configured gcloud CLI and has created project. 

### `Steps to follow`

#### `Step 0. Change configuration`

Go to gcp directory and open _settings.sh_ file. Change the PROJECT_NAME to your project name. If necessary, other variables could be changed i.e. ZONE or REGION.

#### `Step 1. Build project`

Go to 'vertx-http-server' directory and run _mvn clean package_

#### `Step 2. Build Docker image, tag it and push to Google Cloud Container Registry`

Run bash script _docker.sh_. What does this script:
* creates docker image
* tags according to GCP requirements
* push into Google Cloud Container Registry

Command: bash _docker.sh_

#### `Step 3. Create Managed Instance Group with HTTP Load Balancer`

Run script _gcp-set-up-mig.sh_ using command: bash _gcp-set-up-mig.sh_

What is created during running all gcp scripts:
* Instance Template for VM instances which will be created during creation of Managed Instance Group. Container-optimized OS images are used because there is assumption of using docker container with vertx-http-server.
* Firewall rules to allow external and internal traffic.
* HealthCheck for Managed Instance Group
* Managed Instance Group with 2 VM Instances with vertx-http-server container. MIG could be scaled up max. to 10 based on RCP (Request per seconds) to our application.
* HTTP Load Balancer which helps to balance traffic from one external IP address into or VM instances in create MIG. To prove that traffic goes to different VM instances, name of the host machine is return in the message which will be send by the server after invoking HTTP Load Balancer IPAddress with port 8080 -> i.e.31.20.191.0:8080.

After everything will be set up, please wait few minutes during which GCP will be configure created load balancer connection. 

#### `Step 4. Fun :)`

1. Run _gcloud compute instances list_ you can see that two instances was created in one MIG
2. To check whether autoscaling (per RPS) works in our MIG we can generate multiple HTTP requests using simple command: while true; do curl -m1 http://LB_IP_ADDRESS:8080/; done
While script is running you can open second terminal and again write  _gcloud compute instances list_. 
* You should see that number of instances in MIG increases because of too many HTTP requests sends to instances -> This means that autoscaling works :). 
* Also in your terminal you should see that response on sending HTTP requests comes from different VMs -> This means that load balancing works :). 

When you stop the script which are sending HTTP requests, after while you should see that number of VMs instances decreased to started quantity of 2. 


