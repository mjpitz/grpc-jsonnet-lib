default: vendor grpc-metrics/grpc-metrics.json

clean:
	rm -rf vendor

vendor: jsonnetfile.json
	jb install

grpc-metrics/grpc-metrics.json: grpc-metrics/grpc-metrics.jsonnet grafana/*
	jsonnet -J vendor -m grpc-metrics grpc-metrics/grpc-metrics.jsonnet
