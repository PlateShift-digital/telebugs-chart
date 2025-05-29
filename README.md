# Telebugs Chart

This chart helps with hosting telebugs on kubernetes.

## Requirements

This chart relies on CertManager to supply the ssl-certificate for the ingress.

## Setup

### Starting Telebugs up locally

Follow the guide sent to you with your order confirmation.

The first prompt asks you for the domain you telebugs installation should be hosted at. Leave this empty and just let
the command to its thing.

If it fails with the following error message, just execute the command again and it should be done pretty quickly.

```
Error: failed to start container: failed to check container status: context deadline exceeded
```

### Retrieving secrets

Once you are done with drinking your tea and telebugs completed the setup run the following command and store the
result somewhere to access it later.

```shell
# given you have jq installed
docker inspect telebugs | jq ".[0].Config.Env"

# otherwise execute this and look up the value manually (or pipe it into a file that makes it easier to find them).
docker inspect telebugs
```

Note down the following fields from the result:
- `SECRET_KEY_BASE`
- `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`
- `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY`
- `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT`

You can now stop the container running locally with `docker stop telebugs`.

### Chart values

Create a new values file and add the following content.

```yaml
telebugs:
  env:
    secret_key_base: "<SECRET_KEY_BASE>"
    active_record_encryption_primary_key: "<ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY>"
    active_record_encryption_deterministic_key: "<ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY>"
    active_record_encryption_key_derivation_salt: "<ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT>"
registry:
  user: "<YOUR_SIGNUP_MAIL_ADDRESS>"
  password: "<YOUR_TELEBUGS_TOKEN>"
```

Replace the placeholder values with the information you have from the previous step.

Add the ingress information to define how telebugs will be reachable.

```yaml
ingress:
  host: "<the host you want telebugs to be available hat>"
  tls_cert_resolver: "<the cert manager resolver you wish to use>"
```

## Deployment

You can now use the values.yaml + you custom values-yaml to start your telebugs instance.

```shell
helm install telebugs --namespace telebugs telebugs --create-namespace -f values.yaml -f values.custom.yaml
```
