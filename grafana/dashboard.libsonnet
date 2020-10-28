local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local row = grafana.row;

local client = import './client.libsonnet';
local server = import './server.libsonnet';

{
  new(
    prefix='',
    tags=[ 'grpc' ],
    refresh='10s'
  ):: 
    local selector = '$selector';
    dashboard.new(
      '%sgRPC Metrics' % [ prefix ],
      time_from='now-1h',
      tags=tags,
      refresh=refresh,
    )
    .addTemplate({
      current: {
        text: 'default',
        value: 'default',
      },
      hide: 0,
      label: null,
      name: 'datasource',
      options: [],
      query: 'prometheus',
      refresh: 1,
      regex: '',
      type: 'datasource',
    })
    .addTemplate(template.text(
      'selector',
      label='selector',
    ))
    .addRow(
      row.new()
      .addPanel(client.errorRate(selector=selector))
      .addPanel(server.errorRate(selector=selector))
    )
    .addRow(
      row.new()
      .addPanel(client.startRate(selector=selector))
      .addPanel(client.completionRate(selector=selector))
    )
    .addRow(
      row.new()
      .addPanel(client.messageSendRate(selector=selector))
      .addPanel(client.messageReceivedRate(selector=selector))
    )
    .addRow(
      row.new()
      .addPanel(server.startRate(selector=selector))
      .addPanel(server.completionRate(selector=selector))
    )
    .addRow(
      row.new()
      .addPanel(server.messageSendRate(selector=selector))
      .addPanel(server.messageReceivedRate(selector=selector))
    )
    .addRow(
      row.new()
      .addPanel(server.requestDuration(selector=selector,percentile=0.90))
      .addPanel(server.requestDuration(selector=selector,percentile=0.95))
      .addPanel(server.requestDuration(selector=selector,percentile=0.99))
    )
}