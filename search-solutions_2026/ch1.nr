#%%markdown
![overview](images/conceptual-map.png)
#%%markdown
#H1 Steps
1. Set up a Vespa application. We'll use Vespa Cloud for this.
2. Point Vespa CLI to your Vespa Cloud application.
3. Generate mTLS certificates for secure communication with your application.
4. Upload the application package to have your config and schema ready.
5. Feed documents and retrieve them.
#%%markdown
#H1 App package is in vespa-corpus
![app package](images/app-package.png)
#%%markdown
#H1 Install Vespa CLI
![need vespa CLI](images/vespa-cli.png)
#%%bash
# TODO
#%%markdown
#H1 Vespa Cloud Account and Tenant
![Vespa Cloud Account and Tenant](images/cloud-account-tenant.png)
#%%markdown
Create an account on [Vespa Cloud](https://cloud.vespa.ai). </br>
Then do the following:
1. Login to Vespa Cloud Console.
2. Create a new tenant. **Give it a name that starts with training** like `training-<your-name>`.

> [!NOTE]
> You don't need to create an application at this point. It will be created during the first deployment, with the name you give it in the following step.
#%%markdown
#H1 Point Vespa CLI to the Cloud
![](images/vespa-cli-cloud.png)
#%%markdown
#H2 Alternative: point to local
![](images/vespa-cli-local.png)
#%%bash
#H2 Point to Cloud command
vespa config set target cloud
#%%markdown
#H1 Point Vespa CLI to your app
![app which doesn't exist yet - we'll create later](images/vespa-cli-app.png)
#%%bash
# Give your tenant and application details.

vespa config set application training1.searchsolutions
#%%markdown
#H2 Authenticate Vespa CLI to work with your account
![](images/vespa-cli-login.png)
#%%bash
#H3 Login as you
vespa auth login
#%%markdown
#H2 Create mTLS certificates
![they go to the app package, too](images/vespa-auth-cert.png)
#%%bash
vespa auth cert vespa-corpus -f
#%%markdown
#H1 Deploy the Application Package
![the app package appears](images/vespa-deploy.png)

This ensures the following:
1. Makes Vespa Cloud understand our schema and other configuration settings, so we can start to feed data and run queries.
2. Store the public certificate (the one copied under `security/clients.pem`) so that Vespa Cloud can authenticate clients.
3. Provisions hosts to store and process data, as specified in `services.xml`. This might take time and consume from the tenant budget (which should be sufficient for training purposes).

> [!NOTE]
> The `--wait 900` parameter is used to wait for the deployment to complete (with a timeout of 900 seconds) and show the logs.
> Once the deployment is complete, check the generated endpoints from the CLI output or the Vespa Cloud console. You’ll have a base URL for querying and feeding data

#%%bash
vespa deploy vespa-corpus --wait 900
#%%markdown
#H1 Point Navigator to your endpoint
This allows the Navigator to work (as Vespa CLI does) with your package and with your app's endpoint:
![](images/vespa-deployed.png)

# TODO
#%%vespa
#H1 Test query (returns no docs)
POST /search/
{
  "yql": "select * from sources * where true"
}
#%%bash
#H1 Feed data
vespa feed --progress 3 vespa-corpus/out/source_file.jsonl
vespa feed --progress 3 vespa-corpus/out/passage.jsonl
#%%vespa
#H1 Test query #2
POST /search/
{
  "yql": "select * from sources * where true"
}