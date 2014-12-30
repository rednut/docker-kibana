USER = rednut
NAME = kibana
REPO = $(USER)/$(NAME)
VERSION = 4.3



RVOL = /data



.PHONY: all build test tag_latest release ssh up run

all: build

build:
	docker build -t="$(REPO):$(VERSION)" --rm .


tag_latest:
	docker tag $(REPO):$(VERSION) $(REPO):latest

release: test tag_latest
	@if ! docker images $(REPO) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(REPO) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(REPO)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

up: run

stop:
	docker stop $(NAME) || echo "cannot stop non running container'$(NAME)'"

rm: stop
	docker rm -f  $(NAME) || echo "container $(NAME) is not prseent"

run: rm
	docker run -d \
		-p 5601:5601 \
		--link  elasticsearch-direct:elasticsearch \
		--name="$(NAME)" \
		$(REPO):$(VERSION) && \
	docker logs --tail="all" -f $(NAME)



ip:
	@ID=$$(docker ps | grep -F "$(REPO):$(VERSION)" | awk '{ print $$1 }') && \
                if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
                IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
                echo "$$IP\tsabnzbd"

ssh:
	chmod 600 image/insecure_key
	@ID=$$(docker ps | grep -F "$(REPO):$(VERSION)" | awk '{ print $$1 }') && \
		if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
		IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
		echo "SSHing into $$IP" && \
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i image/insecure_key root@$$IP
