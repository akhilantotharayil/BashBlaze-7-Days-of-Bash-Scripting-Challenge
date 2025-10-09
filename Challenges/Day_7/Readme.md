````markdown
# 🚀 Bash Blaze Day 7 Challenge - AWS EC2 Deployment

This project demonstrates how to remotely manage EC2 instances using Bash and deploy a containerized web application using Docker and Nginx across multiple AWS EC2 machines.

---

## 🧠 What You'll Learn

- How to set up 3 EC2 instances on AWS
- Configure SSH key-based login (no password)
- Execute remote commands via Bash scripts
- Securely transfer files using `scp`
- Deploy a Dockerized web application using Nginx

---

## 🛠️ Tools Used

- AWS EC2
- SSH / SCP
- Bash
- Docker
- Nginx

---

## 🪜 Step-by-Step Guide

### ✅ 1. Launch 3 EC2 Instances

Go to **AWS Console > EC2 > Launch Instance**:

- AMI: Amazon Linux 2 or Ubuntu 20.04
- Instance Type: `t2.micro` (Free Tier eligible)
- Names:
  - `server`
  - `client1`
  - `client2`
- Key Pair: Create or select an existing one (download `.pem` file)
- Security Group Rules:
  - Allow **SSH (port 22)** from your IP
  - Allow **HTTP (port 80)** from anywhere (`0.0.0.0/0`)

> 📌 Save each instance’s **public IP address** for later use.

---

### ✅ 2. Connect to Instances via SSH

```bash
chmod 400 your-key.pem

ssh -i "your-key.pem" ec2-user@<SERVER_IP>
ssh -i "your-key.pem" ec2-user@<CLIENT1_IP>
ssh -i "your-key.pem" ec2-user@<CLIENT2_IP>
````

> For Ubuntu instances, use `ubuntu@<IP>` instead of `ec2-user`.

---

### ✅ 3. Set Up SSH Key Authentication (Passwordless)

On **server EC2**:

```bash
ssh-keygen -t rsa
# Press ENTER for all prompts
```

Copy the public key to clients:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub ec2-user@<CLIENT1_IP>
ssh-copy-id -i ~/.ssh/id_rsa.pub ec2-user@<CLIENT2_IP>
```

> If `ssh-copy-id` isn’t available, manually copy the contents of `~/.ssh/id_rsa.pub` to each client's `~/.ssh/authorized_keys`.

---

### ✅ 4. Run Remote Commands with Bash Script

Create `remote_execute.sh` on the **server**:

```bash
#!/bin/bash

for host in <CLIENT1_IP> <CLIENT2_IP>
do
  echo "Running command on $host"
  ssh ec2-user@$host "uname -a && hostname && mkdir -p /Akhil_Test"
done
```

Usage:

```bash
chmod +x remote_execute.sh
./remote_execute.sh
```

---

### ✅ 5. Securely Transfer Files with SCP

Create `secure_transfer.sh` on the **server**:

```bash
#!/bin/bash

FILE="sample.txt"
echo "Hello from server!" > $FILE

for host in <CLIENT1_IP> <CLIENT2_IP>
do
  echo "Transferring $FILE to $host"
  scp $FILE ec2-user@$host:/home/ec2-user/
done
```

Usage:

```bash
chmod +x secure_transfer.sh
./secure_transfer.sh
```

---

### ✅ 6. Create & Containerize Web App

On **server**:

#### Create the Web App

```bash
mkdir webapp && cd webapp
```

Create `index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>CodeCrafters Web App</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(to right, #1f1c2c, #928dab);
      color: #ffffff;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      text-align: center;
    }
    .container {
      background: rgba(255,255,255,0.1);
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.3);
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Welcome to CodeCrafters Web App</h1>
    <p class="footer">Hosted By Akhil</p>
  </div>
</body>
</html>
```

#### Create `Dockerfile`

```Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

#### Build & Export Docker Image

```bash
sudo apt update && sudo apt install -y docker.io
sudo docker build -t codecrafters-webapp .
sudo docker save codecrafters-webapp > webapp.tar
```

---

### ✅ 7. Deploy Docker Web App on Clients

#### Transfer Image to Clients

```bash
scp webapp.tar ec2-user@<CLIENT1_IP>:~
scp webapp.tar ec2-user@<CLIENT2_IP>:~
```

#### On each client, create `deploy_app.sh`:

```bash
#!/bin/bash

# Load Docker image
sudo docker load < webapp.tar

# Stop & remove any existing container
sudo docker stop webapp 2>/dev/null
sudo docker rm webapp 2>/dev/null

# Run container
sudo docker run -d --name webapp -p 80:80 codecrafters-webapp
```

#### Run Script on Each Client

```bash
chmod +x deploy_app.sh
./deploy_app.sh
```

---

## ✅ Final Verification

* Visit `http://<CLIENT1_IP>` and `http://<CLIENT2_IP>` in your browser.
* You should see the **CodeCrafters Web App** hosted by **Akhil**.

---

## 📌 Notes

* Ensure **port 80** is open in the security group of client instances.
* Replace `ec2-user` with `ubuntu` if you're using Ubuntu AMIs.
* You can automate more of this using Ansible or SSH agent forwarding if scaling further.

---

## 🙌 Credits

Built as part of the **Bash Blaze Challenge** – Day 7 by Akhil.


