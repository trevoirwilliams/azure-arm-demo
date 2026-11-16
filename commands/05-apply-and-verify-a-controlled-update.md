# Apply and verify a controlled update

Start with the dev account from [guide 04](04-deploy-and-reproduce-infrastructure.md). If you are starting here or deleted the dev account, use the dev-only route in steps 1–3 of that guide.

Run from the repository root. In a fresh terminal, restore `subscriptionId`, `resourceGroup` and `devName` using the assignment syntax in guide 04. Use the values from your original deployment. Open `.infrastructure/dev.parameters.json` and confirm its storage account name and region match the deployed resource. Copy it to `.infrastructure/updated.parameters.json` and change only `parameters.ownerLabel.value` from `course-demo` to `platform-team`. Keep the dev file for reset.

## Record the baseline and preview

```sh
# Record the account ID, owner label, SKU, region and access settings before preview.
az storage account show --subscription "$subscriptionId" --resource-group "$resourceGroup" --name "$devName" --query "{id:id,owner:tags.owner,location:location,sku:sku.name,httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,anonymousBlob:allowBlobPublicAccess,sharedKey:allowSharedKeyAccess,network:publicNetworkAccess}" --output json
# Preview the change. Expect Modify on that account and the requested owner change.
az deployment group what-if --subscription "$subscriptionId" --resource-group "$resourceGroup" --template-file .infrastructure/main.bicep --parameters '@.infrastructure/updated.parameters.json' --mode Incremental
```

Confirm the baseline reports `owner=course-demo`. Stop if the preview proposes a new account, a deletion, or changes you cannot explain. The deployment reapplies the resource definition in incremental mode, so review the full preview for the existing account before applying.

## Apply and verify

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
