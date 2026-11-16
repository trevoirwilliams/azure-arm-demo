# Author a Bicep definition

Use the starter files from the lesson or practice with the existing repository definition. The course bundle uses `starter/main.bicep`; in this repository, run from the root and substitute `.infrastructure/main.bicep`. Use a fresh output path such as `.infrastructure/authoring-check.json` to preserve the existing generated template.

```sh
# Check the Azure CLI-managed compiler version.
az bicep version
# If the managed compiler is missing, install it before building.
az bicep install
# Compile the edited file locally. Inspect main.json for one storage account and three outputs.
az bicep build --file starter/main.bicep --outfile starter/main.json
```

Standalone compiler alternative:

```sh
# Check the version installed on your PATH.
bicep --version
# Produce the same kind of ARM JSON locally.
bicep build starter/main.bicep --outfile starter/main.json
```

The build reads the Bicep source. Check the separate JSON input file independently. The command does not contact Azure to create resources.

[Microsoft Learn: Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-cli)
