# bitwarden-cli-init

[![Continuous integration](https://github.com/x-real-ip/bitwarden-cli-init/actions/workflows/ci.yaml/badge.svg)](https://github.com/x-real-ip/bitwarden-cli-init/actions/workflows/ci.yaml)
![GitHub repo size](https://img.shields.io/github/repo-size/x-real-ip/bitwarden-cli-init?logo=Github)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/x-real-ip/bitwarden-cli-init?logo=github)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/x-real-ip/bitwarden-cli-init/main?logo=github)

<img src="https://github.com/x-real-ip/kubernetes-gitops/blob/main/assets/img/k8s.png?raw=true" alt="K8s" style="height: 30px; width:30px;"/>
Application running in Kubernetes


This Kubernetes pod deployment can serve as an init container to retrieve a
secret from a Bitwarden vault and share it with the main container(s) through a
file. You can mount this file into the main container(s).

To use this, create a Kubernetes secret with the credentials for your
Bitwarden/Vaultwarden instance. For instance, I am utilizing sealedsecret to
encrypt passwords and other secrets

```yaml
kind: SealedSecret
apiVersion: bitnami.com/v1alpha1
metadata:
  name: bitwarden-cli-env-secrets
  namespace: tools
  lables:
    app.kubernetes.io/name: bitwarden-cli
    app.kubernetes.io/component: cli
    app.kubernetes.io/instance: production
    app.kubernetes.io/part-of: vaultwarden
spec:
  encryptedData:
    BW_CLIENTID: "Your bitwarden client ID"
    BW_CLIENTSECRET: "Your bitwarden client secret"
    BW_PASSWORD: "Your bitwarden password"
  template:
    metadata:
      labels:
        app: bitwarden-cli
      name: bitwarden-cli-env-secrets
      namespace: tools
    type: Opaque
```

It pulls, by default, a 'username,' 'password,' and 'TOTP' and saves them in a
file at this location: `/tmp/.retrieved.env`. Use the command
`eval $(cat /tmp/.retrieved.env)` to make the variables available as OS
environment variables inside the container(s)."

```bash
cat <<EOF >/tmp/.retrieved.env
RETRIEVED_USERNAME="${USERNAME}"
RETRIEVED_PASSWORD="${PASSWORD}"
RETRIEVED_TOTP="${TOTP}"
EOF
```
