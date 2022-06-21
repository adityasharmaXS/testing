# Approaches

## Available Scripts
### Engine Service:
   - It will target the remaining services, main part is to cover the pulsar.
   - Pulsar hpa-scaling script will be enabled for only hpa, no volume-deletion script needed in hpa-scaling script
   - Pulsar components will be directly scaled down, hpa won't be having effect when the replica is to 0.
   - In this script volume-deletion will be integrated and it will be only for pulsar.
   - Parameters available: `eng-services.turn: on/off`
   - **Important:** Once the pulsar block is scaled up, do trigger the of [pulsar-function](https://github.com/webdataworks/pulsar-functions/tree/dev) workflow from git. keep checking with below this command: `kubectl get sts -n dataworks-app | grep pulsar` each component should be having some replicas like: `1/1`

## Available Processes

### Pulsar Decommission

Note: It is not possible to completely decommission the pulsar as it requires replication of ledgers.
1. Review the quorum, the `quorum` should be greater than `1`, minimum `2`.
2. For pulsar scaling, we have separate `configmaps` and `hooks` for both scale-up and scale-down.
3. Use the `eng-service.turn` parameter for scaling, the `off` will delete and scale-down the pulsar components while `on` will scale-up.

### Pulsar resize
1. Delete the hpas of pulsar components(later can be up by ArgoCD application `scale-script`)
2. Delete the helm charts with volume and functions(if any).
3. Update the helm chart for resource, volume size and storage class
4. Install the updated chart
5. Run the pulsar function workflow from [pulsar-function](https://github.com/webdataworks/pulsar-functions/tree/dev)
6. Re-run the `scale-script` and integrate the hpas.
7. Delete the unused volumes.

### Pulsar Optimization
1. Add pulsar block in hpa scaling script
2. Configure the volumes of bookie journal and ledgers
3. Resource limit configure if required.
4. Separate script for volumes deletion
5. Keep a check hooks weight
6. If we can scale down the sts/deploy to 0 the hpa will no-longer be affecting it.
