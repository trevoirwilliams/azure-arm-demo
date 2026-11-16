targetScope = 'resourceGroup'

@description('Globally unique name: 3-24 lowercase letters and digits. Keep unchanged for updates.')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Use a region permitted by your subscription or supplied workspace.')
param location string = resourceGroup().location

@allowed(['dev', 'test'])
param environmentName string = 'dev'

@description('Exercise metadata. Never put credentials or personal information in tags.')
param ownerLabel string = 'course-demo'


resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: {
    environment: environmentName
    owner: ownerLabel
    purpose: 'arm-repeatability'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Disabled'
  }
}

output storageId string = storage.id
output storageName string = storage.name
output deployedLocation string = storage.location
