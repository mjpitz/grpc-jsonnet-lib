# grpc-jsonnet-lib

A jsonnet library for writing gRPC dashboards as code.
For now, my focus is on the Grafana and Prometheus ecosystem.
I tried to leave room for Datadog.

## How to use

This library can be used two different ways.
The easy way is to use one of our [pre-built dashboards](#pre-built-dashboards).
You can quickly import the dashboard's JSON file into Grafana to start observing your gRPC services.

The second way to use this library is to add it as a dependency using [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler).
This way, you can leverage our building blocks to assemble your own dashboard.

```json
{
  "version": 1,
  "dependencies": [
    {
      "source": {
        "git": {
          "remote": "https://github.com/mjpitz/grpc-jsonnet-lib.git",
          "subdir": "."
        }
      },
      "version": "main"
    },
  ],
}
```

Once added as a dependency, you can import it to start building:

```jsonnet
local grpc_grafana = import 'github.com/mjpitz/grpc-jsonnet-lib/grafana/grafana.libsonnet';

local client = grpc_grafana.client;   # for client side metrics
local server = grpc_grafana.server;   # for server side metrics
local slis = grpc_grafana.slis;       # for common service level indicators
local slos = grpc_grafana.slos;       # for common service level objectives
```

## Pre-built Dashboards

### gRPC metrics [ [dashboard.json](grpc-metrics/grpc-metrics.json) ]

Graphs:

- Client call start rate
- Client call completion rate
- Client message send rate
- Client message receive rate
- Server call start rate
- Server call completion rate
- Server message send rate
- Server message receive rate
- Request Duration (p90)
- Request Duration (p95)
- Request Duration (p99)

![dashboard screenshot](grpc-metrics/grpc-metrics.png)
![](https://www.google-analytics.com/collect?v=1&tid=UA-172921913-1&cid=555&t=pageview&ec=repo&ea=open&dp=%2Fgrpc-jsonnet-lib&dt=%2Fgrpc-jsonnet-lib)
