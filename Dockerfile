FROM rednut/ubuntu
MAINTAINER stuart <stuart@rednut.net>

RUN \
	apt-get update -y && \
	apt-get install -y default-jre-headless 

RUN \
	mkdir -p /opt/kibana && \
	curl "https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-beta3.tar.gz" \
		| tar -xvz -C /opt/kibana --strip-components=1 && touch /opt/kibana/.installed-timestamp

RUN \
	sed -i 's/^elasticsearch:/#elasticsearch:/' /opt/kibana/config/kibana.yml && \
	echo "\nelasticsearch: \"http://elasticsearch:9200\"" >> /opt/kibana/config/kibana.yml

EXPOSE 5601

WORKDIR /opt/kibana

CMD /opt/kibana/bin/kibana
