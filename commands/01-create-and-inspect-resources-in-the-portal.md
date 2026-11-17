# Create and inspect resources in the portal

Lecture 17 shows a dedicated resource group, an empty storage account, JSON View, and deletion of that group. This guide uses explicit HTTPS, TLS and access settings for the exercise. Keep the defaults for SMB encryption and soft delete unless your workspace specifies otherwise. The recording skips tags. The tags below are optional for this portal activity.

Use your approved subscription and region. Keep the account empty and check the applicable storage charges before you create it.

1. Sign in to the Azure portal. Search for **Resource groups** and open the group supplied by your workspace. In your own subscription, create a dedicated exercise group if you have permission.
2. Search for **Storage accounts** and select **Create**. Select your subscription and group, choose your region, and enter a globally unique name with 3–24 lowercase letters and digits. Choose **Standard** performance and **Locally-redundant storage (LRS)**.
3. Require secure transfer and minimum TLS 1.2. Turn off anonymous blob access and storage account key access. Under **Networking**, disable public network access. Keep optional services, including SFTP and private endpoints, off. To practice tagging, open **Tags** and add `purpose=arm-repeatability`, `environment=dev`, and `owner=course-demo`.
4. Select **Review + create**, check the scope and settings, and then select **Create**. When deployment succeeds, select **Go to resource**. Verify the subscription, group, region, redundancy, resource ID, and tags. Use **JSON View** if available to confirm `StorageV2` and `Standard_LRS`.
5. Open the resource group’s **Deployments** page and check the result. When you finish, delete the exercise storage account and verify it disappears from the group. Keep any group supplied by your workspace. Delete a personal exercise group only after checking that it is empty.

[Create an Azure storage account](https://learn.microsoft.com/azure/storage/common/storage-account-create) · [View deployment history](https://learn.microsoft.com/azure/azure-resource-manager/templates/deployment-history) · [Optional budget alerts](https://learn.microsoft.com/azure/cost-management-billing/costs/tutorial-acm-create-budgets)
