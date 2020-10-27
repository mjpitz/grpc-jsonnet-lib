local grpc_grafana = import '../grafana/grafana.libsonnet';

{
  'grpc-metrics-grafana.json': grpc_grafana.dashboard.new(),
}
