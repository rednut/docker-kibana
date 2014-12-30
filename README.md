# Kibana 4 dockerisation 

## usage, basic

Get the docker image:
`docker pull rednut/kibana:latest`


Start container running kibana:
`docker run -d -p 5601:5601 rednut/kibana`


Please note that this will try to connect to an elasticsearch instance using the hostname `elasticsearch` at port 9200, this way you can either talk to a non dockerised elasticsearch node _or_ use container linking described below to automaticaly point kibana to an elasticsearch node.


## usage, linked to elasticsearch container

By linking to an elasticsearch container, kibana will know where to find an elasticserch node, for example to link to an easticsearch insance called elasticsearch-direct you could launch the container as:

```
docker run -d \
	--link elasticsearch-direct:elasticsearch \
	-p 5601:5601 \
	rednut/kibana
```



## Source code and make files

Included is a make file to assist with tasksL
- make build
- make run port=15601
- make run-linked link=elastyicsearch-direct


# TODO, Bugs and life

1) TODO: lots
	apply cli vars like port and link to makefile!

2) crawlerble
3) use figs


