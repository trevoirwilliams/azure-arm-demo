# Author a Bicep definition

Open a terminal at the repository root. Inspect `.infrastructure/main.bicep` for the resource group scope, four parameters, one storage account and three outputs. `.infrastructure/dev.parameters.json` supplies values for deployment. `.infrastructure/main.json` is the checked-in ARM template. Build to `.infrastructure/authoring-check.json` so you can inspect a fresh result alongside that reference.

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

The build reads the Bicep source. Check the separate JSON input file independently. The command does not contact Azure to create resources.

[Microsoft Learn: Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-cli)
