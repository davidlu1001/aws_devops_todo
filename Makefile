.PHONY: test release clean version login logout

export APP_VERSION ?= $(shell git rev-parse --short HEAD)
export REGION ?= "ap-southeast-2"
export ACCOUNT_ID ?= "348807118004"

version:
	@ echo '{"Version": "$(APP_VERSION)"}'

login:
	aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

logout:
	docker logout https://${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

test:
	docker-compose build --pull release
	docker-compose build
	docker-compose run test

release:
	docker-compose up --abort-on-container-exit migrate
	docker-compose run app python3 manage.py collectstatic --no-input
	docker-compose up -d app
	@ echo App running at http://$$(docker-compose port app 8000 | sed s/0.0.0.0/localhost/g)

clean:
	docker-compose down -v
	docker images -q -f dangling=true -f label=application=todobackend | xargs -I ARGS docker rmi -f --no-prune ARGS