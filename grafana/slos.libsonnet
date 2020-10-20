local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;

{
  /**
   */
  availability(
    selector,
    slo_days=30,
    slo_target=0.99,
    datasource='$datasource',
    span=4,
  ):: singlestat.new(
    'Availability (%dd) > %.3f%%' % [slo_days, 100 * slo_target],
    datasource=datasource,
    span=span,
    format='percentunit',
    decimals=3,
    description='Successfully answered requests over the last %d days' % slo_days,
  ).addTarget(prometheus.target(
    'sum(rate(grpc_server_handled_total{grpc_code!="Unavailable",grpc_code!="Unknown",%s}[%dd])) / sum(rate(grpc_server_handled_total{%s}[%dd]))' % [
      selector,
      slo_days,
      selector,
      slo_days,
    ],
  )),

  /**
   */
  errorBudget(
    selector,
    slo_days=30,
    slo_target=0.99,
    datasource='$datasource',
    span=8,
  ):: graphPanel.new(
    'ErrorBudget (%dd) > %.3f%%' % [slo_days, 100 * slo_target],
    datasource=datasource,
    span=span,
    format='percentunit',
    decimals=3,
    fill=10,
    description='How much error budget is left looking at our %.3f%% availability guarantees' % [100 * slo_target]
  ).addTarget(prometheus.target(
    '100 * (sum(rate(grpc_server_handled_total{grpc_code!="Unavailable",grpc_code!="Unknown",%s}[%dd])) / sum(rate(grpc_server_handled_total{%s}[%dd])) - %f)' % [
      selector,
      slo_days,
      selector,
      slo_days,
      slo_target,
    ],
    legendFormat='errorbudget'
  )),
}
