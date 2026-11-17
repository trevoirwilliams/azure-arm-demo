# Azure Resource Manager course commands

Use the lecture number from **Section 4: Azure Resource Manager and Infrastructure As Code** to find your place.

| Lecture | Follow along |
| --- | --- |
| 17 · Create Resources via Azure Portal | [Create and inspect resources in the portal](01-create-and-inspect-resources-in-the-portal.md) |
| 18 · Understanding Azure CLI and Additional Management Tools | [Compare Azure CLI and Azure PowerShell](#compare-azure-cli-and-azure-powershell) |
| 19 · Explore The Azure Cloud Shell | [Run the CLI exercise in Cloud Shell Bash](02-inspect-and-update-resources-with-azure-cli.md#1-open-a-terminal-and-select-the-subscription) |
| 20 · Using Azure CLI Locally | [Install, sign in and check context](02-inspect-and-update-resources-with-azure-cli.md#lecture-20-quick-path-using-azure-cli-locally) |
| 23 · Author a Bicep definition | [Author and compile the definition](03-author-a-bicep-definition.md) |
| 24 · Deployment Verification Methods and Steps | [Compile](03-author-a-bicep-definition.md), [validate and preview](04-deploy-and-reproduce-infrastructure.md#2-validate-and-preview-dev), then [read the deployed resource](04-deploy-and-reproduce-infrastructure.md#3-deploy-dev-and-verify) |
| 25 · Validate, Simulate and Deploy Bicep Defined Resources | [Validate, preview, deploy and verify dev](04-deploy-and-reproduce-infrastructure.md) |

Lectures 14–16, 21–22 and 26 cover concepts or review. After Lecture 25, you can also [apply and verify a controlled update](05-apply-and-verify-a-controlled-update.md) or [diagnose failures and clean up resources](06-diagnose-failures-and-clean-up-resources.md).

Open a terminal at the repository root, the folder containing `.infrastructure`. The Bicep source is `.infrastructure/main.bicep`. Set your own values in `.infrastructure/dev.parameters.json` before deploying. The checked-in `.infrastructure/main.json` lets you inspect the equivalent ARM template. Run one command at a time and stop on errors or unexpected results. Keep any group your workspace supplied and remove only resources you created.

## Compare Azure CLI and Azure PowerShell

Lecture 18 compares two ways to inspect an existing storage account. Use an account you can read. Replace the subscription ID, group and account placeholders. Azure CLI (`az`) works in Bash and PowerShell. Azure PowerShell (`Get-AzStorageAccount`) uses the Az modules and returns objects you can pipe to `Select-Object`. The two tools have separate sign-in and context commands.

**Azure CLI** (run `az login` in a local terminal if needed)

```sh
az account show --query "{subscription:name,subscriptionId:id,tenant:tenantId}" --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"
az storage account show --name "YOUR_ACCOUNT" --resource-group "YOUR_GROUP" --output json
```

**Azure PowerShell** (use a terminal with Az.Accounts and Az.Storage, and run `Connect-AzAccount` locally if needed)

```powershell
Set-AzContext -Subscription "YOUR_SUBSCRIPTION_ID" -ErrorAction Stop
Get-AzContext
Get-AzStorageAccount -Name "YOUR_ACCOUNT" -ResourceGroupName "YOUR_GROUP" | Select-Object Location
```

Check the subscription and tenant before reading the resource. The Azure CLI example returns the account as JSON. Compare its `location` with the location selected by the Azure PowerShell pipeline. For the deployment exercise in Lecture 25, use the `az deployment group` examples even when your terminal is PowerShell.

[Azure CLI and Azure PowerShell comparison](https://learn.microsoft.com/azure/developer/azure-cli/choose-the-right-azure-command-line-tool) · [Get-AzStorageAccount](https://learn.microsoft.com/powershell/module/az.storage/get-azstorageaccount) · [Deploy an ARM template using Azure PowerShell](https://learn.microsoft.com/azure/azure-resource-manager/templates/deploy-powershell)
