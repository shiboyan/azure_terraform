name: 'Terraform'

on:
  push:
    branches:
      - "dev"
  pull_request:
    branches:
      - "dev"

permissions:
  contents: write
  id-token: write
jobs:
  terraform:
    name: 'Terraform'
    env:
      ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.AZURE_SECRET_ID }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      tf_actions_working_dir: ./tf
    runs-on: ubuntu-latest
    environment: dev
    defaults:
      run:
        shell: bash
        working-directory: ${{ env.tf_actions_working_dir }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Login to Azure
        uses: azure/login@v1
        with:
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          client-id: ${{ secrets.AZURE_CLIENT_ID}}
      # Install the latest version of Terraform CLI and configure the Terraform CLI configuration file with a Terraform Cloud user API token
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
      - name: Terraform Init
        id: init
        run: |
          terraform workspace new dev
          terraform workspace select dev
          terraform init
      - name: Terraform Format
        run: terraform fmt -check
      - name: 'Terraform Validate'
        if: github.event_name == 'pull_request'
        run: terraform validate
        continue-on-error: true

        # Generates an execution plan for Terraform
      - name: 'Terraform Plan'
        if: github.event_name == 'pull_request'
        run: terraform plan -var 'env=dev'
        continue-on-error: true
      - name: 'Terraform Apply'
        #        if: github.event_name == 'pull_request'
        #if: github.ref == 'refs/heads/"develop"' && github.event_name == 'pull_request'
        run: terraform apply -var 'env=dev' -auto-approve
  terraform_prod:
    name: 'Terraform_prod'
    env:
      ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.AZURE_SECRET_ID }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      tf_actions_working_dir: ./tf
    runs-on: ubuntu-latest
    environment: production
    defaults:
      run:
        shell: bash
        working-directory: ${{ env.tf_actions_working_dir }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Login to Azure
        uses: azure/login@v1
        with:
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          client-id: ${{ secrets.AZURE_CLIENT_ID}}
      # Install the latest version of Terraform CLI and configure the Terraform CLI configuration file with a Terraform Cloud user API token
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
      - name: Terraform Init
        id: init
        run: |
          terraform workspace new production
          terraform workspace select production
          terraform init
      - name: Terraform Format
        run: terraform fmt -check
      - name: 'Terraform Validate'
        if: github.event_name == 'pull_request'
        run: terraform validate
        continue-on-error: true

        # Generates an execution plan for Terraform
      - name: 'Terraform Plan'
        if: github.event_name == 'pull_request'
        run: terraform plan -var 'env=production'
        continue-on-error: true
      - name: 'Terraform Apply'
        #        if: github.event_name == 'pull_request'
        #if: github.ref == 'refs/heads/"develop"' && github.event_name == 'pull_request'
        run: terraform apply -var 'env=production' -auto-approve

