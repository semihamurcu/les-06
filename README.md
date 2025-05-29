# Hybride Cloud Project - "Hello World" Docker CI/CD

## 📋 Inhoud
1. [Overzicht](#overzicht)
2. [Projectflow](#projectflow)
3. [Benodigdheden](#benodigdheden)
4. [Instructies](#instructies)
5. [CI/CD Uitleg](#cicd-uitleg)
6. [Testen](#testen)

---

## 📌 Overzicht
In dit project zet ik een hybride cloudomgeving op met:
- 1 VM in **Azure**
- 1 VM op een **ESXi hypervisor**
- Beide VM’s draaien een **Hello World** Docker-container via CI/CD.

---

## 🔁 Projectflow

1. **VM’s aanmaken** via Terraform (Azure & ESXi)  
   → `main.tf`, `providers.tf`, `variables.tf`, `terraform.tfvars`, `metadata.yaml.tftpl`, `userdata.yaml`

2. **Docker installeren** met Ansible  
   → `install_docker.yaml`

3. **Docker image bouwen en pushen** naar Docker Hub met GitHub Actions  
   → `.github/workflows/docker.yml` (in je repo), `docker-hello/Dockerfile`

4. **Docker container draaien** op beide VM's met Ansible  
   → `run_hello_world.yaml`

5. **Testen via browser of curl** op poort 80


---

## 🧰 Benodigdheden

- Terraform
- Ansible
- Docker
- GitHub Actions
- Docker Hub account
- ESXi server & Azure account

---

## 🛠️ Instructies

### 🔨 Stap 1 - Terraform
Gebruik Terraform om de Azure en ESXi VM’s te deployen:

terraform init
terraform apply

### 🐧 Stap 2 - Docker installatie met Ansible
ansible-playbook -i inventory.ini install_docker.yaml

### 📦 Stap 3 - Build & Push Docker image
De Docker image wordt automatisch gepusht bij elke commit naar main. De relevante workflow staat in .github/workflows/docker.yml.

Docker image: semihamurcu66/hello-world:latest

### 🚀 Stap 4 - Docker container starten op beide VM's
ansible-playbook -i inventory.ini run_hello_container.yaml

## ⚙️ CI/CD Uitleg
De GitHub Actions pipeline:

* Logt in bij Docker Hub
* Bouwd de Dockerfile in docker-hello/
* Pusht het image naar Docker Hub

Workflow trigger: bij een push naar main.

## ✅ Testen
Gebruik curl of je browser:
curl http://<VM-IP>



### 📁 Projectstructuur

les-06-1/
├── docker-hello/
│   └── Dockerfile
├── install_docker.yaml
├── run_hello_world.yaml
├── main.tf
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── terraform.tfstate
├── terraform.tfstate.backup
├── metadata.yaml.tftpl
├── userdata.yaml
└── README.md
