local grpc_grafana = import '../grafana/grafana.libsonnet';

{
  'grpc-metrics.json': grpc_grafana.dashboard.new(),
}
