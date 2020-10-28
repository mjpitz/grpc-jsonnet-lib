local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;

{
  errorRate(
    selector,
    datasource='$datasource',
    span=6,
    min=0,
  ):: graphPanel.new(
    'Client Call Error Rate',
    datasource=datasource,
    span=span,
    format='call/s',
    min=0,
  ).addTarget(prometheus.target(
    (
      '( sum(rate(grpc_client_handled_total{grpc_code="Unavailable",%s}[5m])) by (grpc_service, grpc_method, instance) +' +
      '  sum(rate(grpc_client_handled_total{grpc_code="Unknown",%s}[5m])) by (grpc_service, grpc_method, instance) ) / ' +
      'sum(rate(grpc_client_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)'
    ) % [
      selector, selector, selector,
    ],
  )),

  startRate(
    selector,
    datasource='$datasource',
    span=6,
    min=0,
  ):: graphPanel.new(
    'Client Call Start Rate',
    datasource=datasource,
    span=span,
    format='call/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_started_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),

  completionRate(
    selector,
    datasource='$datasource',
    span=6,
    min=0,
  ):: graphPanel.new(
    'Client Call Completion Rate',
    datasource=datasource,
    span=span,
    format='call/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),

  messageReceivedRate(
    selector,
    datasource='$datasource',
    span=6,
    min=0,
  ):: graphPanel.new(
    'Client Message Receive Rate',
    datasource=datasource,
    span=span,
    format='msg/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_msg_received_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),


  messageSendRate(
    selector,
    datasource='$datasource',
    span=6,
    min=0,
  ):: graphPanel.new(
    'Client Message Send Rate',
    datasource=datasource,
    span=span,
    format='msg/s',
  ).addTarget(prometheus.target(
    'sum(rate(grpc_client_msg_sent_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  )),
}