#%%markdown
#H1 Prerequisites
1. [Vespa CLI](https://docs.vespa.ai/en/clients/vespa-cli.html) --> install instructions below.
2. `git`
3. `python3 -> python`
3. A coding agent.
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
#H2 On Mac/brew
brew install vespa-cli
#%%bash
#H2 Mise
#mise use vespa-cli
#%%markdown
#H1 Download binary and put it in PATH
[GitHub link](https://github.com/vespa-engine/vespa/releases)
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
#H2 Give your tenant and application details
vespa config set application <TENANT_NAME>.<APPLICATION_NAME>
vespa config get
#%%markdown
#H1 Authenticate Vespa CLI to work with your account
![](images/vespa-cli-login.png)
#%%bash
#H3 Login as you
vespa auth login
#%%markdown
#H1 Create mTLS certificates
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
This allows the Navigator to work (as Vespa CLI does) with your package and with your app's endpoint
![](images/vespa-deployed.png)

# TODO
#%%vespa
#H1 Test query (returns no docs)
POST /search/
{
  "yql": "select * from sources * where true"
}
#%%bash
#H1 Download corpus
git clone --depth 1 https://github.com/vespa-engine/vespa git-checkouts/vespa
git clone --depth 1 https://github.com/vespa-engine/sample-apps git-checkouts/sample-apps
git clone --depth 1 https://github.com/vespa-engine/documentation git-checkouts/documentation
#%%bash
#H1 Make it indexable
python3 vespa-corpus/scripts/select_files.py
python3 vespa-corpus/scripts/chunk.py
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
#%%bash
#H1 Install Vespa Skills (pick your own coding agent)
vespa skills install --harness cursor --local
#%%markdown
#H1 Ask your agent questions
Have a look at AGENTS.md

Then ask your coding agents questions like the ones below (inspired from [Vespa 101](https://docs.google.com/presentation/d/1wZldEi77PQRbysZrGxJH0RKQMTkXZZbFAKUzNL2IxzY))

### replace with your coding agent below
#%%bash
#H2 What is Vespa?
cursor-agent -p "What is Vespa?"
#%%markdown
#H2 Popular questions
1. What are Vespa's known fits and known misfit use-cases?
2. What can go in an application package?
3. What kind of documents go in Vespa? How are they represented? Tell me about document types, schemas, namespaces, IDs and their relationship.
4. Tell me about data structures: summary, index, attribute. When to use which?
5. What is a tensor? When are tensors best fits and when they look like they are but they aren't?
6. Tell me about Vespa's ranking phases and when to use which? Use visuals
7. How does Vespa's distributed model work? What are the trade-offs it makes compared to Solr's? Now I really need visuals
#%%bash
#H1 Remove the deployment if you don't need it
vespa destroy --force