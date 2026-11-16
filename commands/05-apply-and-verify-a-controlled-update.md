# Apply and verify a controlled update

Start with the dev account from lesson 04. If it was removed, use that lesson to deploy only dev. Reuse its shell variables and run from the repository root. Copy `.infrastructure/dev.parameters.json` to `.infrastructure/updated.parameters.json` and change only `ownerLabel.value` from `course-demo` to `platform-team`. Keep the original dev file for reset.

```sh
# Record the account ID, owner label, SKU, region and access settings before preview.
az storage account show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$devName" --query "{id:id,owner:tags.owner,location:location,sku:sku.name,httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,anonymousBlob:allowBlobPublicAccess,sharedKey:allowSharedKeyAccess,network:publicNetworkAccess}" --output json
# Preview the change. Expect Modify on that account and the requested owner change.
az deployment group what-if --subscription "$subscriptionId" --resource-group "$resourceGroup" --template-file .infrastructure/main.bicep --parameters '@.infrastructure/updated.parameters.json' --mode Incremental
```

Stop if the preview proposes a new account, a deletion, or changes you cannot explain. After review, apply and read back the same resource.

```sh
# Apply the reviewed inputs and read the deployment state and returned ID.
az deployment group create --subscription "$subscriptionId" --resource-group "$resourceGroup" --name arm-update --template-file .infrastructure/main.bicep --parameters '@.infrastructure/updated.parameters.json' --mode Incremental --query "{state:properties.provisioningState,id:properties.outputs.storageId.value}" --output json
# Verify the ID and required configuration match the baseline and the owner is platform-team.
az storage account show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$devName" --query "{id:id,owner:tags.owner,location:location,sku:sku.name,httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,anonymousBlob:allowBlobPublicAccess,sharedKey:allowSharedKeyAccess,network:publicNetworkAccess}" --output json
# Preview the same desired state again. The intended owner change should no longer be pending.
az deployment group what-if --subscription "$subscriptionId" --resource-group "$resourceGroup" --template-file .infrastructure/main.bicep --parameters '@.infrastructure/updated.parameters.json' --mode Incremental
```

If you want to repeat the update from the original owner value, preview the original `.infrastructure/dev.parameters.json` using the same what-if command, then reapply it using the same create command with `--name arm-reset`. Read the account again and check that the same ID reports `course-demo`. Use lesson 06 for cleanup.

[Microsoft Learn: What-if](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-what-if) · [Incremental mode](https://learn.microsoft.com/azure/azure-resource-manager/templates/deployment-modes)
