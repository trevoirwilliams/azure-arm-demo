# Validate, preview and deploy Bicep-defined resources

Lecture 24 explains the checkpoints. Lecture 25 runs steps 1–3 through the successful dev deployment and describes a second parameter file. Step 4 is optional reproduction practice. The recording runs inside `.infrastructure` with short filenames. Run these commands from the repository root and keep the `.infrastructure/` path prefixes. In PowerShell, a backtick at the end of the line continues a command. Bash uses a backslash. The one-line versions below work in either shell.

Deploy one dev account. To practice reproduction, deploy a second account with a different set of inputs and compare the two.

## Before you deploy

Open a terminal at the repository root. Use the checked-in `.infrastructure/main.bicep` and `.infrastructure/dev.parameters.json`. If you choose to reproduce the deployment, make a local copy of `.infrastructure/dev.parameters.json` named `.infrastructure/reproduce.parameters.json` and set the values using the input table below. The Bicep definition uses `Microsoft.Storage/storageAccounts@2023-05-01`.

- Use Azure CLI with its Bicep compiler available (`az version` and `az bicep version`). For a local terminal, sign in with `az login` if necessary. In a managed workspace use its provided sign-in and group. Run one command at a time and stop after any unexpected result or error.
- Use an approved subscription and region. Confirm the `Microsoft.Storage` provider is available and the region supports `StorageV2` with `Standard_LRS`. Confirm policy, quota for two accounts, and the ability to read/delete the accounts. Deployments and what-if normally require resource write access plus `Microsoft.Resources/deployments/*`. Creating a personal group requires subscription-level group creation access. Have the administrator resolve any inaccessible scope or provider setup.
- Keep both accounts empty. This definition adds no private endpoints, data, or paid add-ons. Check the actual pricing and any subscription-level services such as Defender before provisioning. Two empty Standard LRS accounts are chosen to keep the exercise small. Charges depend on the actual subscription, region and usage.

## 1. Set the target and prepare two input sets

Use the same variables in Bash or PowerShell. Copy only the assignment syntax for your terminal and replace the example values. Use a fresh group name for a personal run. In a managed workspace, set the group variable to the supplied name.

```bash
subscriptionId='YOUR_SUBSCRIPTION_ID'
resourceGroup='rg-bicep-deploy-7k4m2'
location='YOUR_APPROVED_REGION'
devName='stbicepdev7k4m2'
testName='stbiceptest7k4m2'
```

```powershell
$subscriptionId = 'YOUR_SUBSCRIPTION_ID'
$resourceGroup = 'rg-bicep-deploy-7k4m2'
$location = 'YOUR_APPROVED_REGION'
$devName = 'stbicepdev7k4m2'
$testName = 'stbiceptest7k4m2'
```

Use the remaining commands in either shell. Check that the returned subscription matches your intended target. Reuse your dedicated Lecture 19 group if it still exists and you have verified its scope and inventory. For a new personal group, choose an unused name and create it only after the existence check succeeds and prints `false`. In a managed workspace skip the personal group commands and use the supplied group.

```sh
# Selects the subscription for this CLI session.
az account set --subscription "$subscriptionId"
# Displays the selected subscription and tenant; confirm both before writes.
az account show --query "{name:name,subscriptionId:id,tenant:tenantId}" --output table
```

Personal run only:

```sh
# Returns true if the named group exists, otherwise false.
az group exists --subscription "$subscriptionId" --name "$resourceGroup"
# Creates the dedicated exercise group. Expect Succeeded.
az group create --subscription "$subscriptionId" --name "$resourceGroup" --location "$location" --output table
```

Both routes:

```sh
# Reads group metadata and confirms the target.
az group show --subscription "$subscriptionId" --name "$resourceGroup" --query "{name:name,id:id,location:location}" --output json
# Checks availability. Look for nameAvailable: true.
az storage account check-name --subscription "$subscriptionId" --name "$devName" --output json

```

Choose an available dev account name with 3–24 lowercase letters or digits. For the optional second run, choose a different name and check its availability in step 4. If a managed workspace denies the subscription-level name check, confirm the account creation route is allowed and use fresh unique suffixes. Name availability can still change before creation. Edit the JSON values before proceeding. The variables above do not update the files. The checked-in dev name and region are examples. Set the dev file to your approved values now. Prepare the reproduction file only if you plan to run step 4.

| JSON path under `parameters` | `.infrastructure/dev.parameters.json` | `.infrastructure/reproduce.parameters.json` |
|---|---|---|
| `storageAccountName.value` | Value of `devName` | Value of `testName` |
| `location.value` | Approved region | Same approved region |
| `environmentName.value` | `dev` | `test` |
| `ownerLabel.value` | `course-demo` | `course-demo` |

## 2. Validate and preview dev

```sh
# Validates the deployment request without applying resource changes.
az deployment group validate --subscription "$subscriptionId" --resource-group "$resourceGroup" --template-file .infrastructure/main.bicep --parameters '@.infrastructure/dev.parameters.json'
# Previews resource changes. Confirm the expected Create or Modify before continuing.
az deployment group what-if --subscription "$subscriptionId" --resource-group "$resourceGroup" --template-file .infrastructure/main.bicep --parameters '@.infrastructure/dev.parameters.json' --mode Incremental
```

The quotes keep the `@file` argument intact in Bash and PowerShell. Validation checks the deployment request. What-if predicts changes against the target without applying them. For this empty starting state the declared storage account should appear as **Create** with the dev name. A shared group may also show unrelated resources as **Ignore**. Stop on unexpected changes, deletes, or diagnostics that prevent you from confirming the intended operation. For an existing declared account, incremental mode reapplies the template properties. An omitted property can reset to its default. Review the full proposed change. Deployment can still fail after a successful preview.

## 3. Deploy dev and verify

```sh
# Applies the definition in incremental mode. Check the provisioning state and deployment outputs.
az deployment group create --subscription "$subscriptionId" --resource-group "$resourceGroup" --name bicep-dev --template-file .infrastructure/main.bicep --parameters '@.infrastructure/dev.parameters.json' --mode Incremental --query "{state:properties.provisioningState,outputs:properties.outputs}" --output json
# Reads the named account. Compare the selected fields with the prior command or intended settings.
az storage account show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$devName" --query "{id:id,location:location,kind:kind,sku:sku.name,tags:tags,httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,anonymousBlob:allowBlobPublicAccess,sharedKey:allowSharedKeyAccess,network:publicNetworkAccess}" --output json
```

The deployment should report `Succeeded` and return `storageId`, `storageName` and `deployedLocation`. Compare the returned `storageId.value` with the direct read’s `id`. Read the dev tag and check the expected settings in the table below. Keep the full ID for the deployment and cleanup record.

## 4. Optional: Reproduce with the test file

Ensure `.infrastructure/reproduce.parameters.json` contains the distinct test name and the approved settings from step 1. Check name availability, validate and preview using that file. Expect **Create** for the test account. The dev account falls outside this deployment’s declared resources and is retained under incremental mode. Apply only after reviewing the preview.

```sh
az storage account check-name --subscription "$subscriptionId" --name "$testName" --output json
az deployment group validate --subscription "$subscriptionId" --resource-group "$resourceGroup" --template-file .infrastructure/main.bicep --parameters '@.infrastructure/reproduce.parameters.json'
az deployment group what-if --subscription "$subscriptionId" --resource-group "$resourceGroup" --template-file .infrastructure/main.bicep --parameters '@.infrastructure/reproduce.parameters.json' --mode Incremental
# Applies the definition in incremental mode. Check the provisioning state and deployment outputs.
az deployment group create --subscription "$subscriptionId" --resource-group "$resourceGroup" --name bicep-test --template-file .infrastructure/main.bicep --parameters '@.infrastructure/reproduce.parameters.json' --mode Incremental --query "{state:properties.provisioningState,outputs:properties.outputs}" --output json
# Reads the named account. Compare the selected fields with the prior command or intended settings.
az storage account show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$testName" --query "{id:id,location:location,kind:kind,sku:sku.name,tags:tags,httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,anonymousBlob:allowBlobPublicAccess,sharedKey:allowSharedKeyAccess,network:publicNetworkAccess}" --output json
# Lists accounts in scope. After cleanup, verify the removed account names are absent.
az storage account list --subscription "$subscriptionId" --resource-group "$resourceGroup" --query "[].{Account:name,Region:location,Kind:kind,Sku:sku.name,Environment:tags.environment,Owner:tags.owner}" --output table
```

Compare the test deployment outputs with the test resource read, then compare both account reads. The list can include pre-existing accounts in a supplied group. Identify the two names you chose.

| Check | Expected result |
|---|---|
| Deployment state | Both `Succeeded`. |
| Identity | Two names and two IDs. Both IDs contain the same subscription, group and resource type. |
| Tags | `environment=dev` versus `environment=test`. Both retain `owner=course-demo` and `purpose=arm-repeatability`. |
| Configuration | Same approved location, `StorageV2`, `Standard_LRS`, HTTPS only `true`, `TLS1_2`, anonymous blob access `false`, Shared Key `false`, public network access `Disabled`. |
| Portal cross-check (optional) | Refresh the resource group’s **Overview** and **Deployments**. Locate both accounts and the two named deployment records. |

## 5. End state and cleanup

If you are going directly into **Apply and verify a controlled update**, keep dev with `owner=course-demo`. Save `.infrastructure/dev.parameters.json` and its ID and retain the group. Once you’ve compared both accounts, delete the test account if you no longer need it. For a standalone run, delete both accounts you created. Verify each name against the IDs you recorded before confirming deletion. Skip the dev deletion if you’re continuing to the update lesson.

```sh
# Run only if you deployed the test account in step 4.
az storage account delete --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$testName"
# Deletes the exact exercise account. Confirm the target when prompted.
az storage account delete --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$devName"
# Lists accounts in scope. After cleanup, verify the removed account names are absent.
az storage account list --subscription "$subscriptionId" --resource-group "$resourceGroup" --query "[].name" --output json
```

Confirm the deleted names are absent. If the group was created solely for this demo and both accounts are gone, first run the inventory command below. Proceed with group deletion only when it succeeds and returns `[]`. Verify `false` after deletion. Keep any supplied group in place.

```sh
# Lists resources in the group. Require an empty result before deleting a dedicated demo group.
az resource list --subscription "$subscriptionId" --resource-group "$resourceGroup" --output json
# Deletes the dedicated group. Verify absence with az group exists.
az group delete --subscription "$subscriptionId" --name "$resourceGroup"
# Returns true if the named group exists, otherwise false.
az group exists --subscription "$subscriptionId" --name "$resourceGroup"
```

## Recovery

| Symptom | Action |
|---|---|
| Invalid or taken storage name | Choose a fresh name. Update both the relevant JSON file and its shell variable before previewing again. |
| Authorization or policy error | Check the active subscription, target group, approved role, region, SKU and provider. Review the inner policy or access error. |
| Deployment failed or terminal disconnected | Inspect the named deployment and group inventory before retrying. A failed operation can leave resources behind. |
| Second preview shows a modification to dev | Check that the second file and test name were actually used. Stop until the preview targets the intended identity. |
| Deletion fails | Inspect the error for access restrictions or locks. Treat cleanup as pending until the account or disposable group is confirmed absent. |

To inspect an existing deployment record, use the appropriate name (`bicep-dev` or `bicep-test`):

```sh
# Reads deployment history and state for the specified deployment.
az deployment group show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name bicep-dev --output json
```

## References

Microsoft Learn references checked 17 November 2026.

- [Deploy Bicep with Azure CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-cli), [deployment CLI commands](https://learn.microsoft.com/cli/azure/deployment/group) and [JSON parameter files](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameter-files).
- [Bicep what-if](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-what-if), [incremental mode](https://learn.microsoft.com/azure/azure-resource-manager/templates/deployment-modes) and [deployment history](https://learn.microsoft.com/azure/azure-resource-manager/templates/deployment-history).
- [Storage CLI](https://learn.microsoft.com/cli/azure/storage/account), [naming errors](https://learn.microsoft.com/azure/azure-resource-manager/troubleshooting/error-storage-account-name) and [Storage billing](https://learn.microsoft.com/azure/storage/common/storage-account-overview#storage-account-billing).
- [Subscription commands](https://learn.microsoft.com/cli/azure/account), [resource providers](https://learn.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types) and [group deletion](https://learn.microsoft.com/azure/azure-resource-manager/management/delete-resource-group).

