# Voice App Helm Chart

This Helm chart deploys the Voice app on a Kubernetes cluster.

```
voice/
├── Chart.yaml
├── values.yaml
├── charts/
│   └── redis-17.8.4.tgz
├── templates/
│   ├── _helpers.tpl
│   ├── configmap.yaml
│   ├── deployment-webapp.yaml
│   ├── deployment-worker.yaml
│   ├── ingress.yaml
│   └── service-webapp.yaml
└── .helmignore
```

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `voice-app`:

```bash
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm dependency update ./voice
helm install voice-app ./voice
```

These commands add the stable Helm repository, update the repository cache, update the chart dependencies, and install the Voice app Helm chart.

## Uninstalling the Chart

To uninstall/delete the `voice-app` deployment:

```bash
helm delete voice-app
```

This command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Voice app chart and their default values.

| Parameter                | Description             | Default        |
|--------------------------|-------------------------|----------------|
| `replicaCount`           | Number of replicas      | `1`            |
| `image.repository`       | Image repository        | `abhikgho/text_to_speech_web_app` |
| `image.tag`              | Image tag               | `web-v1.0.3`   |
| `image.pullPolicy`       | Image pull policy       | `IfNotPresent` |
| `service.type`           | Kubernetes Service type | `ClusterIP`    |
| `service.port`           | Service port            | `5000`         |
| `ingress.enabled`        | Enable ingress          | `false`        |
| `resources`              | CPU/Memory resource requests/limits | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install voice-app ./voice --set replicaCount=2
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example:

```bash
helm install voice-app ./voice -f ./voice/values.yaml
```

## Persistence

The Voice app uses PersistentVolumes to store PDF uploads and generated audio files. The chart mounts a PersistentVolume at `/app/uploads` and `/app/output`. The PersistentVolume is created using dynamic volume provisioning.

## Scaling

You can scale the deployment by changing the `replicaCount` parameter. However, note that you may need to implement additional logic for handling file storage across multiple replicas.

## Upgrading

To upgrade the Voice app deployment:

```bash
helm upgrade voice-app ./voice-app
```

To forward a service port using kubectl, you can use the kubectl port-forward command. It creates a connection from your local port 8080 to port 80 of the voice-app-webapp service.
The -n voice-app specifies the namespace where the service is located.

```bash
kubectl port-forward -n voice-app service/voice-app-webapp 3000:80
```
After running this command, you should be able to access the service by opening a web browser and navigating to http://localhost:3000.

## Troubleshooting

If you encounter issues with the Helm chart deployment:

1. Check the Kubernetes pod status:
   ```
   kubectl get pods
   ```

2. View the logs of the Voice app pod:
   ```
   kubectl logs <pod-name>
   ```

3. Describe the pod to see events and conditions:
   ```
   kubectl describe pod <pod-name>
   ```

4. Ensure all required values are properly set in your `values.yaml` file or through the `--set` flag.

For more information on using Helm, refer to the [Helm documentation](https://helm.sh/docs/).


## Support and Contributing

### Support the Project
If you find this project helpful, consider supporting its development:

[![Support via PayPal](https://img.shields.io/badge/Support%20via-PayPal-blue.svg)](https://paypal.me/abhikghosh87)

Every contribution helps maintain and improve the service! Your support enables:
- 🚀 Regular updates and improvements
- 📚 Better documentation
- 🛠️ New features development
- 🐛 Faster bug fixes
- 💬 Responsive support

### Connect & Contribute

- 🌟 Star this repository if you find it helpful
- 🔗 Follow on [LinkedIn](https://www.linkedin.com/in/abhik-ghosh-msc/) for updates
- 💬 Join our [My website](https://abhikghosh87.wixsite.com/website)
- 📝 Check out my [Blog Posts](https://medium.com/@abhikghosh_46536)

### Support the Project

If you find this project helpful, consider supporting its development:

- 💖 PayPal: [paypal.me/abhikghosh87](https://paypal.me/abhikghosh87)
- ⭐ Star this repository
- 📣 Share with others

### Technical Support
For technical questions and issues:
- Open an issue in the repository
- Contact the cloud infrastructure team

## License

MIT License - see the [LICENSE](LICENSE) file for details

---
Made with ❤️ by the community. Special thanks to all our supporters!