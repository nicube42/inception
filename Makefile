up:
	cd ./srcs && docker-compose up -d

down:
	cd ./srcs && docker-compose down

rebuild:
	cd ./srcs && docker-compose up -d --build

wp-shell:
	cd ./srcs && docker exec -it wordpress /bin/sh

db-shell:
	cd ./srcs docker exec -it mariadb /bin/sh

nginx-shell:
	cd ./srcs docker exec -it nginx /bin/sh

reset-all:
	docker stop mariadb
	docker stop nginx
	docker stop wordpress
	docker rm mariadb
	docker rm nginx
	docker rm wordpress
	docker system prune -af --volumes
	docker system prune -af --volumes

reset-docker:
	docker stop $(docker ps -a -q) || true
	docker rm $(docker ps -a -q) || true
	docker rmi $(docker images -q) || true
	docker volume prune --force
	docker volume rm srcs_db_data srcs_wordpress_data
