local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;

{
  startRate(
    selector,
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Server Call Start Rate',
    datasource=datasource,
    span=span,
    format='call/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_server_started_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),

  completionRate(
    selector,
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Server Call Completion Rate',
    datasource=datasource,
    span=span,
    format='call/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_server_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),

  messageReceivedRate(
    selector,
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Server Message Receive Rate',
    datasource=datasource,
    span=span,
    format='msg/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_server_msg_received_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),

  messageSendRate(
    selector,
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Server Message Send Rate',
    datasource=datasource,
    span=span,
    format='msg/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_server_msg_sent_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),

  requestDuration(
    selector,
    percentile=0.95,
    datasource='$datasource',
    span=4,
  ):: graphPanel.new(
    'Request Duration @ %.3f%%' % [ percentile * 100 ],
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