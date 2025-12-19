# Hello React + Spring Boot (single Maven project) + Azure (Terraform) + GitHub Actions

This repository contains a **single Maven project** that:
- Builds a **React** frontend (Vite)
- Copies the React build output into `src/main/resources/static`
- Packages everything into **one executable Spring Boot JAR**
- Deploys that JAR to **Azure Linux App Service** using **Terraform** and **GitHub Actions**

---

## 1) What you get

- Backend: `GET /api/hello` returns a plain text message
- Frontend: one button → calls `/api/hello` → displays the response
- Maven build (`mvn clean package`) does, in order:
  1. Installs Node + npm locally (via Maven plugin)
  2. Builds the React app
  3. Copies `frontend/dist` → `src/main/resources/static`
  4. Builds the Spring Boot executable JAR

---

## 2) Prerequisites (local)

- Java 21
- Maven 3.9+

No separate Node install is required for *build*, because Maven installs Node/npm for the frontend build.

---

## 3) Run locally

### Build the single JAR (includes React)
```bash
mvn clean package
```

### Run it
```bash
java -jar target/hello-react-spring-0.0.1-SNAPSHOT.jar
```

Open:
- Frontend: http://localhost:8080/
- Backend:  http://localhost:8080/api/hello

---

## 4) How React and Spring Boot are integrated

- React sources are in: `frontend/`
- React build output is: `frontend/dist/`
- During Maven build, we copy `frontend/dist/` into:
  - `src/main/resources/static`

Spring Boot automatically serves static assets from `classpath:/static/`.
So the React app is served by the **same** Spring Boot app (no CDN, no separate hosting).

For SPA refreshes / client-side routes, `SpaWebConfig` forwards unknown paths to `/index.html`.

---

## 5) Azure infrastructure with Terraform

Terraform files are in `terraform/`.

### 5.1 Prerequisites
- Terraform >= 1.6
- Azure subscription
- An Azure Service Principal with permission to create:
  - Resource Group, App Service Plan, Linux Web App

### 5.2 Configure variables
Copy and edit:
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

**Important:** set a unique `name_prefix`.  
Azure Web App names must be globally unique because they become part of the hostname.

Example:
```hcl
name_prefix = "pierluigi-hello-rs"
```

### 5.3 Deploy infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After apply, Terraform outputs:
- `app_name`
- `app_default_hostname`

---

## 6) CI/CD with GitHub Actions

Workflow: `.github/workflows/deploy.yml`

It:
1. checks out code
2. runs `mvn clean package` (which also builds React)
3. logs into Azure using a Service Principal JSON from GitHub Secret `APP_CREDENTIALS`
4. deploys `target/app.jar` to Azure Web App using `azure/webapps-deploy`

### 6.1 Required GitHub Secrets

Create these repository secrets:

#### `APP_CREDENTIALS`
A JSON Service Principal credential (the exact format expected by `azure/login`), for example:

```json
{
  "clientId": "<appId>",
  "clientSecret": "<password>",
  "subscriptionId": "<subscriptionId>",
  "tenantId": "<tenantId>"
}
```

#### `AZURE_WEBAPP_NAME`
The Azure Web App name created by Terraform (value of Terraform output `app_name`).

---

## 7) End-to-end deployment steps

1. **Provision infra**
   - Run Terraform in `terraform/`
   - Note the output `app_name`

2. **Set GitHub secrets**
   - `APP_CREDENTIALS`: Service Principal JSON
   - `AZURE_WEBAPP_NAME`: value from Terraform output

3. **Push to `main`**
   - GitHub Actions will build and deploy automatically

4. **Open the app**
   - `https://<app_default_hostname>/`
   - Click the button → it calls `/api/hello`

---

## 8) Notes / simplicity constraints

- Everything is reproducible from code and documented steps
- No separate frontend hosting
- No manual deployment steps beyond Terraform and GitHub Secrets setup


$env:ARM_SUBSCRIPTION_ID="XXXXXXXXXXXX"

az ad sp create-for-rbac --name "github-deployer" --role contributor --scopes /subscriptions/XXXXXXXXXXXX --sdk-auth

add it into github repository secrets as APP_CREDENTIALS


