# Inspect and update resources with Azure CLI

**Short instructor activity · 6–8 minutes, excluding provisioning waits.** Start with no resources from the portal demo. Create an empty storage account, inspect it, update one tag, then remove everything created for the activity. Run the commands in either Azure Cloud Shell or a local terminal.

## Sign in locally if needed

```sh
# Show the installed CLI version.
az version
# Sign in interactively and select an accessible account.
az login
```

## 1. Open a terminal and select the subscription

- **In the portal:** Open **Cloud Shell** from the top toolbar. Choose **Bash** and, if prompted, **No storage account required**, then select the approved subscription and **Apply**. Cloud Shell signs you in using your portal identity. The subscription used for Cloud Shell requires the `Microsoft.CloudShell` provider to be registered. If registration is blocked, use the local route where permitted. Persistent mode uses an Azure Files share and can incur storage charges. Use the no-storage option for this activity or use a local terminal.
- **Locally:** Open PowerShell or Bash. Run `az version`. If the command is missing, install Azure CLI for your OS and reopen the terminal. Run `az login` and complete the sign-in prompts, including MFA if requested. Use the account that has access to your approved subscription.

Set four variables. Replace the sample names with your own, using a unique suffix. A storage account name must be globally unique and contain 3–24 lowercase letters or digits. Choose an approved region. Use the supplied group name if working in a restricted Udemy workspace.

**Bash (including Cloud Shell)**

```bash
subscriptionId='YOUR_SUBSCRIPTION_ID'
location='YOUR_APPROVED_REGION'
resourceGroup='rg-cli-activity-7k4m2'
storageAccount='stcliactivity7k4m2'
```

**PowerShell**

```powershell
$subscriptionId = 'YOUR_SUBSCRIPTION_ID'
$location = 'YOUR_APPROVED_REGION'
$resourceGroup = 'rg-cli-activity-7k4m2'
$storageAccount = 'stcliactivity7k4m2'
```

The remaining commands work in either shell. Run them one at a time and stop on any error. Check that the subscription matches the intended one before creating anything.

```sh
# Selects the subscription for this CLI session.
az account set --subscription "$subscriptionId"
# Displays the selected subscription and tenant; confirm both before writes.
az account show --query "{subscription:name,id:id,tenant:tenantId}" --output table
```

[Cloud Shell first-run setup](https://learn.microsoft.com/azure/cloud-shell/get-started/ephemeral) · [Cloud Shell file persistence](https://learn.microsoft.com/azure/cloud-shell/persisting-shell-storage) · [Install Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) · [Interactive CLI sign-in](https://learn.microsoft.com/cli/azure/authenticate-azure-cli-interactively) · [Subscription context](https://learn.microsoft.com/cli/azure/manage-azure-subscriptions-azure-cli)

## 2. Create one empty storage account

**Personal subscription.** Confirm you have permission to create and delete a resource group and manage the account inside it. Confirm the chosen group name is unused. Continue only if the first command succeeds and prints `false`.

```sh
# Returns true if the named group exists, otherwise false.
az group exists --subscription "$subscriptionId" --name "$resourceGroup"
# Creates the dedicated exercise group. Expect Succeeded.
az group create --subscription "$subscriptionId" --name "$resourceGroup" --location "$location" --query "{name:name,state:properties.provisioningState}" --output table
```

**Restricted workspace.** Use the supplied group. Skip group creation. Confirm that the workspace allows the chosen region and account configuration and has granted account create, read, update and delete permissions.

```sh
# Reads group metadata and confirms the target.
az group show --subscription "$subscriptionId" --name "$resourceGroup" --query "{name:name,location:location}" --output table
```

Check the storage account name. Continue only when `nameAvailable` is true. If the workspace denies only the subscription-level name check, use a fresh unique suffix and proceed only if account creation in the supplied group is authorized. If a name is taken, change the suffix and retry.

```sh
# Checks availability. Look for nameAvailable: true.
az storage account check-name --subscription "$subscriptionId" --name "$storageAccount" --query "{nameAvailable:nameAvailable,reason:reason}" --output json
# Creates the empty Standard LRS account with the specified access settings and tag. Expect Succeeded.
az storage account create --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$storageAccount" --location "$location" --kind StorageV2 --sku Standard_LRS --access-tier Hot --https-only true --min-tls-version TLS1_2 --allow-blob-public-access false --allow-shared-key-access false --public-network-access Disabled --tags purpose=cli-activity --query "{name:name,sku:sku.name,state:provisioningState}" --output table
```

**Expected:** one account with SKU `Standard_LRS` and provisioning state `Succeeded`. Pause the recording during provisioning. Keep the account empty, skip data uploads and avoid optional paid services. This configuration is intended to keep cost low. Actual charges depend on region, usage and any subscription-level services or policies. Check the applicable pricing and settings before creating the resource. The activity does not assume free-tier eligibility or guarantee a zero bill.

[Resource group CLI commands](https://learn.microsoft.com/cli/azure/group) · [Storage account CLI commands and flags](https://learn.microsoft.com/cli/azure/storage/account) · [Storage billing factors](https://learn.microsoft.com/azure/storage/common/storage-account-overview#storage-account-billing) · [Azure Blob Storage pricing](https://azure.microsoft.com/en-us/pricing/details/storage/blobs/)

## 3. Inspect and tag the account

```sh
# Reads the named account. Compare the selected fields with the prior command or intended settings.
az storage account show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$storageAccount" --query "{id:id,kind:kind,sku:sku.name,tags:tags}" --output json
```

Check the name at the end of the ID and the subscription and group earlier in the path. Copy the account’s entire ID into the command below. `Merge` adds the new tag and keeps `purpose=cli-activity`.

```sh
# Merges the lifecycle tag and preserves the existing purpose tag. Verify with show.
az tag update --resource-id "PASTE_FULL_STORAGE_ACCOUNT_RESOURCE_ID" --operation Merge --tags lifecycle=temporary --output none
# Reads the named account. Compare the selected fields with the prior command or intended settings.
az storage account show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$storageAccount" --query "{id:id,tags:tags}" --output json
```

**Expected:** same resource ID and both tags, `purpose=cli-activity` and `lifecycle=temporary`.

[CLI tag update](https://learn.microsoft.com/cli/azure/tag#az-tag-update) · [Tag behavior and permissions](https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources)

## 4. Delete and verify

Use the account name, group and subscription you just inspected. Keep the interactive confirmation prompt. After deletion, the account name should be absent from the list. In a new dedicated group, the result should be `[]`. In a shared group, other account names can remain.

```sh
# Deletes the exact exercise account. Confirm the target when prompted.
az storage account delete --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$storageAccount"
# Lists accounts in scope. After cleanup, verify the removed account names are absent.
az storage account list --subscription "$subscriptionId" --resource-group "$resourceGroup" --query "[].name" --output json
```

If you created the group solely for this activity, confirm the full group inventory is empty, then delete the group and verify the final result is `false`. Skip this block for a supplied or shared group.

```sh
# Lists resources in the group. Require an empty result before deleting a dedicated demo group.
az resource list --subscription "$subscriptionId" --resource-group "$resourceGroup" --query "[].{name:name,type:type}" --output json
# Deletes the dedicated group. Verify absence with az group exists.
az group delete --subscription "$subscriptionId" --name "$resourceGroup"
# Returns true if the named group exists, otherwise false.
az group exists --subscription "$subscriptionId" --name "$resourceGroup"
```

**If a command fails:** Recheck the tenant, subscription, region, and permissions. If a policy denies the account configuration, use the policy details to identify an approved route. If creation fails after the group is in place, inspect its inventory and remove any activity resources that were created. If deletion is blocked, check the error for a lock or authorization issue and treat cleanup as outstanding until verified.

[Storage account deletion and list commands](https://learn.microsoft.com/cli/azure/storage/account) · [Group deletion and existence checks](https://learn.microsoft.com/cli/azure/group) · [List group resources](https://learn.microsoft.com/cli/azure/resource#az-resource-list)

