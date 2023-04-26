#テナントID(From Azure AD)
$tenantId="<>"
#サブスクリプションID
$subscriptionId="<>"
#リソースグループ名
$resourceGroup="<>"
#PostgreSQLのホスト名
$HOSTNAME="<>"
$PORT=5432
$DATABASE="<>"
#PostgreSQLのユーザID
$USER="<>"
#PostgreSQLのパスワード
$PASSWORD="<>"
$TARGET_TABLE_NAME="event"
#EventHubの接続文字列
$connectionString="<>"
#EventHubの名
$eventHubName="<>"
$appPlanName=$USER+"sampledemoappplan"
$appName=$USER+"appsamplesmc2jp"
$storageAccountName=$USER+"staccountsamplezzzjp"

#Azureへログイン
az login --tenant "${tenantId}"

#アクティブなサブスクリプションの変更
az account set --subscription "${subscriptionId}"

#ストレージアカウントの作成
az storage account create -n ${storageAccountName} -g ${resourceGroup} -l japaneast --kind StorageV2 --sku Standard_LRS --allow-blob-public-access false --hns true

#App Service プランの作成
az appservice plan create -g ${resourceGroup} -n ${appPlanName} --is-linux --number-of-workers 1 --sku S1

#Functions の作成
az functionapp create -g ${resourceGroup} --runtime python --runtime-version 3.10 --functions-version 4 --name ${appName} --os-type linux --storage-account ${storageAccountName} --plan "/subscriptions/be7d3851-09f6-433c-8da5-09aace58dcd2/resourceGroups/${resourceGroup}/providers/Microsoft.Web/serverfarms/${appPlanName}" --debug

#Functions のアプリケーション設定(環境変数)
az functionapp config appsettings set --name ${appName} --resource-group $resourceGroup --settings AzureWebJobsFeatureFlags=EnableWorkerIndexing SCM_DO_BUILD_DURING_DEPLOYMENT=true HOSTNAME="${HOSTNAME}" PORT="${PORT}" DATABASE="${DATABASE}" USER="${USER}" PASSWORD="${PASSWORD}" TARGET_TABLE_NAME="${TARGET_TABLE_NAME}" eventHubName="${eventHubName}" connectionString="${connectionString}"

#Functionsのソースをデプロイ (Functionsの作成後、数分時間を置いてみる)
func azure functionapp publish ${appName}