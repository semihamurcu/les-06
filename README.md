# Hybride Cloud Project - "Hello World" Docker CI/CD

Opdracht : Maak een complete deployment waarin je een Azure VM en ESXi VM combineert en je een hybrid cloud situatie maakt. Gebruik de stof van de afgelopen lessen. De deployment is compleet geautomatiseerd, inclusief het aanmaken van VM’s en andere resources in Azure.

Je maakt op beide omgeving een gebruiker ‘testuser’ aan, via Ansible of via Terraform. De testuser kan inloggen van de ESXI VM naar de Azure VM, het plaatsen van de benodigde SSH keys is geautomatiseerd.

Op beide systemen draait Docker (wat je geïnstalleerd hebt via een zelfgemaakte ansible-galaxy role) een zelfgemaakte en via CI/CD gebouwde “Hello World” Docker container.

Deze opdracht lever je in samen met de rest van alle opdrachten op uiterlijk de einddatum van het hele vak zoals deze in Brightspace staat.


## Bron
https://chatgpt.com/share/68383be1-0c0c-8002-b06e-7658f68adc0a

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



