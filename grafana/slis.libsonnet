local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;

{
  /**
   */
  requestRate(
    selector,
    datasource='$datasource',
    span=4,
  ):: graphPanel.new(
    'SLI - Request Rates',
    datasource=datasource,
    span=span,
    format='reqps',
    stack=true,
    fill=10,
  ).addTarget(prometheus.target(
    'sum(rate(grpc_server_handled_total{%s}[5m])) by (grpc_code)' % [
      selector,
    ],
    legendFormat='{{ grpc_code }}'
  )),

  /**
   */
  errorRate(
    selector,
    datasource='$datasource',
    span=4,
  ):: graphPanel.new(
    'SLI - Error Rates',
    datasource=datasource,
    span=span,
    min=0,
    format='percentunit',
  ).addTarget(prometheus.target(
    (
      'sum(rate(grpc_server_handled_total{grpc_code="Unavailable",grpc_code="Unknown",%s}[5m])) by (grpc_service, grpc_method) / ' +
      'sum(rate(grpc_server_handled_total{%s}[5m])) by (grpc_service, grpc_method)'
    ) % [
      selector,
      selector,
    ],
    legendFormat='{{ grpc_service }} {{ grpc_method }}',
  )),
  
  /**
   */
  requestDuration(
    selector,
    percentile=0.95,
    datasource='$datasource',
    span=4,
  ):: graphPanel.new(
    'SLI - Request Duration',
    datasource=datasource,
    span=span,
    format='s',
  ).addTarget(prometheus.target(
    'histogram_quantile(%f, sum(rate(grpc_server_handling_seconds_bucket{%s}[5m])) by (le,grpc_service,grpc_method))' % [
      percentile,
      selector,
    ],
    legendFormat='{{ grpc_service }} {{ grpc_method }}',
  )),
}
