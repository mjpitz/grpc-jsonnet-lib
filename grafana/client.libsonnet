local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;

{
  startRate(
    selector,
    window='5m',
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Client Call Start Rate',
    datasource=datasource,
    span=span,
    format='call/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_started_total{%s}[%s])) by (grpc_service, grpc_method, instance)' % [
      selector,
      window,
    ],
  )),

  completionRate(
    selector,
    window='5m',
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Client Call Completion Rate',
    datasource=datasource,
    span=span,
    format='call/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_handled_total{%s}[%s])) by (grpc_service, grpc_method, instance)' % [
      selector,
      window,
    ],
  )),

  messageReceivedRate(
    selector,
    window='5m',
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Client Message Receive Rate',
    datasource=datasource,
    span=span,
    format='msg/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_msg_received_total{%s}[%s])) by (grpc_service, grpc_method, instance)' % [
      selector,
      window,
    ],
  )),


  messageSendRate(
    selector,
    window='5m',
    datasource='$datasource',
    span=6,
  ):: graphPanel.new(
    'Client Message Send Rate',
    datasource=datasource,
    span=span,
    format='msg/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_msg_sent_total{%s}[%s])) by (grpc_service, grpc_method, instance)' % [
      selector,
      window,
    ],
  )),
}