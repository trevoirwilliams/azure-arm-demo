# Diagnose failures and clean up resources

From the repository root, copy `.infrastructure/main.bicep` to `.infrastructure/diagnose.bicep`. Misspell one use of a declared parameter, such as `environmentName`, without changing its declaration. Keep the course source intact.

```sh
# First run: expect an undefined-name diagnostic such as BCP057 or a spelling suggestion.
# Correct the reference and rerun: expect a successful build and a fresh .infrastructure/diagnose.json.
az bicep build --file .infrastructure/diagnose.bicep --outfile .infrastructure/diagnose.json
```

Use `subscriptionId` and `resourceGroup` from lesson 04. Set `deploymentName` to a real deployment record, such as `bicep-dev`, `bicep-test` or `arm-update`. In Bash use `deploymentName='bicep-dev'`. In PowerShell use `$deploymentName = 'bicep-dev'`.

```sh
# Read the result, correlation ID and outer error if present.
az deployment group show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$deploymentName" --query "{state:properties.provisioningState,correlationId:properties.correlationId,error:properties.error}" --output json
# Read failed operations and their messages. A successful deployment normally returns [].
az deployment operation group list --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$deploymentName" --query "[?properties.provisioningState=='Failed'].{target:properties.targetResource.id,message:properties.statusMessage}" --output json
# Inventory the accounts. Compare exact IDs with the accounts you created.
az storage account list --subscription "$subscriptionId" --resource-group "$resourceGroup" --query "[].{name:name,id:id,purpose:tags.purpose}" --output table
```

A missing deployment record calls for checking the subscription, group and name. An invalid or taken storage name calls for fixing the input, whereas access and policy errors call for checking the denied action and governing scope. Inventory the group after a failed deployment before retrying.

Set `accountId` to a verified resource ID from the inventory. In Bash use `accountId='PASTE_FULL_RESOURCE_ID'`. In PowerShell use `$accountId = 'PASTE_FULL_RESOURCE_ID'`. Repeat deletion only for other accounts created by your run.

```sh
# Delete the specified account. Confirm its full ID before proceeding.
az storage account delete --ids "$accountId"
# Verify each deleted ID is absent from a successful list result.
az storage account list --subscription "$subscriptionId" --resource-group "$resourceGroup" --query "[].{name:name,id:id}" --output json
# Inspect the entire group before considering group deletion.
az resource list --subscription "$subscriptionId" --resource-group "$resourceGroup" --output json
```

Keep supplied or shared groups. The last two commands apply only to a group you created for the exercise after a successful full inventory returns `[]`.

```sh
# Delete the dedicated exercise group.
az group delete --subscription "$subscriptionId" --name "$resourceGroup"
# Verify group deletion. Expect false.
az group exists --subscription "$subscriptionId" --name "$resourceGroup"
```

A lock or permission error leaves cleanup outstanding. Deleting a deployment history entry leaves the resources in place.

[Microsoft Learn: Deployment history](https://learn.microsoft.com/azure/azure-resource-manager/templates/deployment-history) · [Storage account CLI](https://learn.microsoft.com/cli/azure/storage/account) · [Group deletion](https://learn.microsoft.com/azure/azure-resource-manager/management/delete-resource-group)
