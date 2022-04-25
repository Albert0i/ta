#
# Import and expose environment variables
#
cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

#
# Main
#
.PHONY: help prune config my-ciapp 

help:
	@echo
	@echo "Usage: make TARGET"
	@echo
	@echo "TA Dockerize project automation helper version 1.1"
	@echo
	@echo "Targets:"
	@echo "	copy		copy source files"
	@echo "	build 		build custom image"
	@echo "	up  		start the app"
	@echo "	down 		stop the app"
	@echo "	ps  		show running containers"
	@echo "	logs		app logs"
	@echo "	cleanup		cleanup source files"
	@echo "	config		edit configuration"

#
# build the Docker image for development
#
copy:
	@printf "Copying source files...\n"
	cp -rfv $(IMAGE_SOURCE)\$(APP_NAME) $(APP_NAME)
	cp -f web.config.template $(APP_NAME)\web.config
	
build:
	@printf "Start building $(IMAGE_NAME):$(IMAGE_VERSION) image...\n"
	docker build --tag $(IMAGE_NAME):$(IMAGE_VERSION) --build-arg APP_NAME=$(APP_NAME) . 

#
# start the app
#
up:
	@printf "Starting the app...\n"
	docker run --name $(APP_NAME) --rm -d -p 80:80 -v $(APP_VOLUME):$(WRITABLE_FOLDER) $(IMAGE_NAME):$(IMAGE_VERSION) 
	@printf "\nBrowse to 'http://$(APP_HOST)/$(APP_NAME)/login.aspx' to run\n"

#
# stop the app
#
down:
	@printf "Stopping the app...\n"
	docker container stop $(APP_NAME)

#
# show running containers
#
ps:
	docker stats --all 

#
# app logs
#
logs:
	@printf "app logs\n"
	docker container logs ta --follow
	
#
# cleanup source files
#
cleanup:
	@printf "Cleaning up source files...\n"
	rm -rfv $(APP_NAME)

#
# edit configuration
#
config:
	nano .env

#
# EOF (2022/04/20)
#
