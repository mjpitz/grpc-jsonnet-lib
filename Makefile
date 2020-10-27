default: out

deps:
	jb install

clean:
	rm -rf vendor
	rm -rf out

out: out/grpc-metrics-grafana.json

out/grpc-metrics-grafana.json: gen/* grafana/*
	mkdir -p out/
	jsonnet -J vendor -m out gen/grpc-metrics-grafana.jsonnet 
