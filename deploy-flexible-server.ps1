$resourceGroup="demo1"
$FlexibleServerName="flexserversmcjp123"
$FlexibleUser="saadmin"
$FlexibleLocation="japaneast"
$FlexiblePassword="1qaz@wsx3edC"
$FlexibleSKU="Standard_B1ms"
$FlexibleIP="0.0.0.0"
$FlexibleStorageSize=128
$FlexibleVersion=14

az postgres flexible-server create --location ${FlexibleLocation} --resource-group ${resourceGroup} `
  --name ${FlexibleServerName} --admin-user ${FlexibleUser} --admin-password ${FlexiblePassword} `
  --sku-name ${FlexibleSKU} --tier Burstable --public-access ${FlexibleIP} --storage-size ${FlexibleStorageSize} `
  --version ${FlexibleVersion}
