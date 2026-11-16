# Azure Resource Manager course commands

Choose the guide that matches what you see in the lesson. The numbers show the order of the hands-on guides.

- [Create and inspect resources in the portal](01-create-and-inspect-resources-in-the-portal.md)
- [Inspect and update resources with Azure CLI](02-inspect-and-update-resources-with-azure-cli.md)
- [Author a Bicep definition](03-author-a-bicep-definition.md)
- [Deploy and reproduce infrastructure](04-deploy-and-reproduce-infrastructure.md)
- [Apply and verify a controlled update](05-apply-and-verify-a-controlled-update.md)
- [Diagnose failures and clean up resources](06-diagnose-failures-and-clean-up-resources.md)

Guide 01 covers the storage-account portal demo. Guide 02 creates and cleans up its own CLI exercise account. Guide 03 builds files locally. Guide 04 creates the dev account used in guide 05. If you are continuing, keep the dev account and save its name, subscription, resource group and full resource ID. Guide 06 covers diagnostics and cleanup.

Run commands from the repository root, the folder that contains `.infrastructure`. The checked-in inputs are `.infrastructure/main.bicep` and `.infrastructure/dev.parameters.json`. `.infrastructure/main.json` is compiled reference output. Lessons 04–06 explain when to make local copies for reproduction, updates, or diagnosis.

Run commands in order within the selected route. Replace the placeholders before running any command, and check the subscription and group before a resource change. Bash and PowerShell have different variable assignments. The command blocks are shared unless labelled otherwise. Where you use an Udemy workspace, keep its supplied group and remove only the accounts you created.


Microsoft Learn references checked 16 November 2026.
