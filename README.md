# Integrating Hashicorp Vault with Openshift/Kubernetes

https://www.vaultproject.io/

## Setup

Scripts in the [vault_setup](vault_setup) folder set up Hashicorp Vault inside an Openshift/Kubernetes cluster.

   * [deploy_vault.sh](vault_setup/deploy_vault.sh)
      * Deploys Vault into its own namespace, see [vault_setup/config/vault.yaml](vault_setup/config/vault.yaml)
      * Deploys a a ConfigMap to configure Vault, see [vault_setup/config/vault-config.json](vault_setup/config/vault-config.json)
      * Exposes the Vault pod as a https route
      
   * [init_vault.sh](vault_setup/init_vault.sh)
      * Initialise Vault
      * Unseal Vault
      * Create and configure a ServiceAccount that Vault can use to to authenticate its clients against the Kubernetes realm
      * Enable and configure Vault to use Kubernetes as it's client identity store. This is useful because each new client Kubernetes name pace gets its own default SA capable of authenticating with Kubernetes and thus also with an appropriately configured Vault. Each namapace/project can use its default SA to obtain secrets.
      * Obtain the Root Token 
      
   * [setup_app_vault_space.sh](vault_setup/setup_app_vault_space.sh)
     * With the Root Token :
     * Create and Configure a policy called "test1", that defines what secrets a "test1" role will have access to
     * Create and configure a role called "test1" and apply the "test1" policy to it.
     * Create some secrets for use by this 
     * Login to vault as the "test1" role and obtain its first token 
     
   * [test_app_vault_space.sh](vault_setup/test_app_vault_space.sh)
     * Using the test1 token obtained in the last step, test that secrets can be ontaind from the test1 namespace in Vault.
     
## Usage

Vault exposes an HTTPS API that clients can use to interact with it. The API can be be leveraged in a variety of ways :
   * Using libraries specifically designed to integrate Vault such as _Spring Cloud Vault_ (https://cloud.spring.io/spring-cloud-vault/)
   * Using commandline http client tools such as _curl_
   
   
### Integrating Spring Boot apps with Vault for secrets management.

Code in the [spring-app-vault-direct](spring-app-vault-direct) folder demonstrates how to inject secrets into a simple Spring Boot app using Spring Cloud Vault

The application code in this project has no knowledge of the existance of vault. Spring Cloud Vault takes charge, authenticates with ault, obtains secrets, and then simply injects secret values into variables defines in the application code of the same key as the secret. eg. the **"password" secret value** we configured in the previous section is simply injected into the **password** variable defined in [VaultDemoClientApplication.java](spring-app-vault-direct/src/main/java/org/jnd/microservices/vault/VaultDemoClientApplication.java) 

Of note within this app are the following files :
   * [spring-app-vault-direct/pom.xml](spring-app-vault-direct/pom.xml) - this defines the library dependencies necessary to use Spring Cloud Vault
   * [spring-app-vault-direct/src/main/resources/bootstrap.yaml](spring-app-vault-direct/src/main/resources/bootstrap.yaml) - this defines :
      * The role the app will use to obtain secrets
      * The location of the Vault server
      * The location in the pod where a JWT can be obtained with which to authenticate with Vault (and thence Kubernetes)
      
### Integrating with Vault using a script and an Init-container.

If it is not possible to make significant changes to an app's source code, it is poosible to execute a script in an init-container in the same pod as the app-container, write secrets to file on a volume shared with the app-container. The app can then simply read secrets from disk.

The folder [script-vault-adapter](script-vault-adapter) contains :
   * [getsecrets.sh](script-vault-adapter/getsecrets.sh) - this script make simple http requests to authenticate with vault and obtain secrets in a json document
   * [Dockerfile](script-vault-adapter/Dockerfile) - the build for a docker image in which the getsecrets.sh script will run
   
The folder [spring-app](spring-app) contains :
   * the source code of very simple app that loads secrets from a file
   * [spring-app-vault-direct-init-container-template.yaml](spring-app/spring-app-vault-direct-init-container-template.yaml) : an openshift template that deploys the simple app, and also an init-container containing the script that interacts with Vault
   * Both container share an ephemeral volume at /tmp, the init-container writes secrets here, and the app conatiner reads them.
   * The secrets file is deleted a short interval after app-container start so that secrets do not remain accessible on the ephemeral volume.  
          