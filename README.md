# Project Setup using below tools
1) Maven
2) Git Hub
3) Jenkins
4) Docker
5) Kubernetes
<img width="940" height="485" alt="image" src="https://github.com/user-attachments/assets/ee61e6fe-6475-417a-b853-d631f6740fdb" />

# Step - 1 : Create EKS Management Host in AWS #

1) Launch new Ubuntu VM using AWS Ec2 ( t2.micro or t3.small or c7i-flex.large - check free tier)
2) Connect to machine via MobaXterm and install kubectl using below commands  
```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```
3) Install AWS CLI latest version using below commands 
```
sudo apt install unzip 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

4) Install eksctl using below commands
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

# Step - 2 : Create IAM role & attach to EKS Management Host & Jenkins Server #
<img width="904" height="256" alt="image" src="https://github.com/user-attachments/assets/17c34c59-aa99-46f6-bdda-3200216a9d32" />

1) Create New Role using IAM service ( Select Usecase - ec2 ) 	
2) Add above permissions as shown in image for the role <br/>		
3) Enter Role Name (eksroleec2) 
4) Attach created role to EKS Management Host (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created) 
5) Attach created role to Jenkins Machine (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created) 

# Step - 3 : Create EKS Cluster using eksctl # 
**Syntax:** 

eksctl create cluster --name cluster-name  \
--region region-name \
--node-type instance-type \
--nodes-min 2 \
--nodes-max 2 \ 
--zones <AZ-1>,<AZ-2>

```
eksctl create cluster --name rkavya-cluster --region ap-south-1 --node-type c7i-flex.large  --zones ap-south-1a,ap-south-1b
```

Note: Cluster creation will take 10 to 15 mins of time (we have to wait and check in the respective region in AWS). After cluster created we can check nodes using below command.	
```
kubectl get nodes  
```

# Step-4 : Jenkins Server Setup in Linux VM #

1) Create Ubuntu VM using AWS EC2 (t2.medium / c7i-flex.large check free tier) <br/>
2) Enable 8080 Port Number in Security Group Inbound Rules
3) Connect to VM using MobaXterm
4) Install Java

URL: https://www.jenkins.io/doc/book/installing/linux/ 
```
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version
```

5) Install Jenkins
```
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins
```
6) Start Jenkins

```
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

7) Verify Jenkins

```
sudo systemctl status jenkins
```
	
8) Open jenkins server in browser using VM public ip

```
http://public-ip:8080/
```

9) Copy jenkins admin pwd
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
	   
10) Create Admin Account & Install Required Plugins in Jenkins

## Step-5 : Setup Docker in Jenkins ##
```
curl -fsSL get.docker.com | /bin/bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo docker version
```
## Step-6 : Jenkins/Maven/Docker configurations ##
1) Configure Maven as Global Tool in Jenkins: Manage Jenkins -> Tools -> Maven Installation -> Add maven <br/>
2) Create docker account URL: https://hub.docker.com/ <br/>
3) Install docker plugin: Manage Jenkins -> plugins -> available plugins -> docker pipeline -> install <br/>
       Select restart Jenkins when installation is complete <br/>
       After restart under installed plugins we can see <br/>
4) For docker credentials setup: Mange Jenkins -> credentials -> system -> global -> add credentials -> username with pswd <br/>
       Username: your docker username <br/>
       Password: docker pswd <br/>
       ID: dockerhub-creds  <br/>
       Description: DockerHub <br/>
       Click Save <br/>
       Verify After saving, you must see: ID: dockerhub-creds <br/>
   
# Step-7 : Install AWS CLI in JENKINS Server #

URL : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html  

**Execute below commands to install AWS CLI**
```
sudo apt install unzip 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
 
# Step-8 : Install Kubectl in JENKINS Server #
**Execute below commands in Jenkins server to install kubectl**

```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

# Step-9 : Update EKS Cluster Config File in Jenkins Server #
	
1) Execute below command in **Eks Management host** & copy kube config file data <br/>
```
cat .kube/config 
```
2) Execute below commands in **Jenkins Server** and paste kube config file  <br/>
```
cd /var/lib/jenkins 
sudo mkdir .kube  
sudo vi .kube/config 
```
From EKS host copy (left click) config file data <br/>
In jenkins server, press i to enter into insert mode, paste the data (right click), press escape and then type :wq, press enter <br/>
To check the data, execute below command in jenkins server
```
sudo cat .kube/config
```

3) Execute below commands in Jenkins Server

```
aws eks update-kubeconfig --region ap-south-1 --name <your-eks-cluster-name>
```

4) check eks nodes <br/>
```
kubectl get nodes 
```
**Note: We should be able to see EKS cluster nodes here.** <br/>
**Now all environment setup is done, you're good to run CI/CD pipeline**

# Step-10 : Create Jenkins CI CD Job #

**Set Github**
1. Go to https://github.com/kavyarangaiah/test1 and fork it to your Git account <br/>
2. To edit code, go to src/main/webapp > WEB-INF > index.jsp
3. To run Pipeline Go to Jenkins UI, create a new job, give name > select pipeline > OK <br/>
4. Once pipeline is selected, go to the job > configure > scroll down and under pipeline script, copy the below code and apply > save <br/>

- **Stage-1 : Clone Git Repo** <br/> 
- **Stage-2 : Maven Build** <br/>
- **Stage-3 : Create & Push Docker Image to Registry** <br/>
   dockerusername/dockerimagename:latest -> dockerusername must be your docker username ( step5(3) ) and the same must be updated in k8s-deploy.yml <br/>
- **Stage-4 : Deploy app in k8s eks cluster** <br/>
- **Stage-5 : Restart the deployment** <br/>
```
pipeline {
    agent any
    
    tools {
        maven "maven-3.9.12"
    }
    
    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/kavyarangaiah/test1.git'
            }
        }
        
        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Docker Build & Push') {
    steps {
        script {
            dockerImage = docker.build("dockerusername/dockerimagename:latest")
            
            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                dockerImage.push()
            }
        }
    }
    
}
        stage('K8s Deployment') {
            steps {
                sh 'kubectl apply -f k8s-deploy.yml' 
            }
        }

        stage('Force K8s Refresh') {
    steps {
        sh 'kubectl rollout restart deployment mavenwebappdeployment'
    }
}
    }
}

```
# Step-11 : Once deployed, can execute below line by line in Jenkins VM #
```
sudo docker images --> this should display the name of docker image build and also its pushed to repository
kubectl get svc --> this should display both Cluster & Loadbalancer details
kubectl get pods --> this should display 2/2 running
kubectl get deployments
```

# Step-12 : Access Application in Browser #
- **We should be able to access our application** <br/>
URL : http://***LB-DNS-Name***/maven-web-app (maven-web-app mentioned in dockerfile tomcat)
	
# We are done with our Setup #
	
**Step-13: After your practise, delete Cluster and other resources we have used in AWS Cloud to avoid billing <br/>**

**DELETE ALL INSTANCES, CLUSTERS, NODES, LBs <br/> DISABLE/DELETE AUTOPAY ENABLED IN UPI TOWARDS AWS**
