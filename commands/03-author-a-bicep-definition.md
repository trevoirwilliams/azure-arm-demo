# Author a Bicep definition

Lecture 23 starts in an empty folder and builds `.infrastructure/main.json`. To follow the authoring on screen, use a separate working folder with a `.infrastructure` subfolder and use this repository as the finished reference. From the root of that separate folder, the recorded build is `az bicep build --file .infrastructure/main.bicep --outfile .infrastructure/main.json`. In this checkout, the command writes `authoring-check.json` so you can compare it with the tracked `main.json`.

Open the repository in your editor and start a terminal at its root. Inspect `.infrastructure/main.bicep` for the resource group scope, four parameters, one storage account and three outputs. `.infrastructure/dev.parameters.json` supplies values for deployment. `.infrastructure/main.json` is the checked-in ARM template. Build to `.infrastructure/authoring-check.json` so you can inspect a fresh result alongside that reference.

```sh
# Check the Azure CLI-managed compiler version.
az bicep version
# If the managed compiler is missing, install it before building.
az bicep install
# Compile the repository definition locally. Inspect authoring-check.json for one storage account and three outputs.
az bicep build --file .infrastructure/main.bicep --outfile .infrastructure/authoring-check.json
```

If an existing compiler is out of date, the recording updates it with `az bicep upgrade`.

Standalone compiler alternative:

```sh
# Check the version installed on your PATH.
bicep --version
# Produce the same kind of ARM JSON locally.
bicep build .infrastructure/main.bicep --outfile .infrastructure/authoring-check.json
```

Open `.infrastructure/authoring-check.json` and find the resource and three outputs. Compare the parameter names with `.infrastructure/dev.parameters.json`. The build reads the Bicep source. Check the separate JSON input file independently. The command does not contact Azure to create resources.

[Microsoft Learn: Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-cli)
