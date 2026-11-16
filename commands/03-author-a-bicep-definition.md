# Author a Bicep definition

Open the repository in your editor and start a terminal at its root. The checked-in [Bicep definition](../.infrastructure/main.bicep) is the completed example. To write along, create an empty `.infrastructure/authoring-check.bicep` and use the completed example to check each stage.

1. Set the deployment scope to `resourceGroup` and declare `storageAccountName`, `location`, `environmentName` and `ownerLabel`.
2. Add the `Microsoft.Storage/storageAccounts@2023-05-01` resource. Connect the name, location and tags to the parameters and use the access settings in the completed example.
3. Add the `storageId`, `storageName` and `deployedLocation` outputs. Compare the four parameter names with [dev.parameters.json](../.infrastructure/dev.parameters.json).
4. Build to `.infrastructure/authoring-check.json` using one of the compiler routes below. To build your own file, substitute `.infrastructure/authoring-check.bicep` for the input path. Compare the fresh output with the checked-in [ARM template](../.infrastructure/main.json).

```sh
# Check the Azure CLI-managed compiler version.
az bicep version
# If the managed compiler is missing, install it before building.
az bicep install
# Compile the repository definition locally. Inspect authoring-check.json for one storage account and three outputs.
az bicep build --file .infrastructure/main.bicep --outfile .infrastructure/authoring-check.json
```

Standalone compiler alternative:

```sh
# Check the version installed on your PATH.
bicep --version
# Produce the same kind of ARM JSON locally.
bicep build .infrastructure/main.bicep --outfile .infrastructure/authoring-check.json
```

Open `.infrastructure/authoring-check.json` and find the resource and three outputs. Compare the parameter names with `.infrastructure/dev.parameters.json`. The build reads the Bicep source. Check the separate JSON input file independently. The command does not contact Azure to create resources.

[Microsoft Learn: Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-cli)
