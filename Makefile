up:
	sudo mkdir -p /home/user0/data
	sudo mkdir -p /home/user0/data/wordpress
	sudo mkdir -p /home/user0/data/db_data
	cd ./srcs && docker-compose up -d

down:
	cd ./srcs && docker-compose down

rebuild:
	cd ./srcs && docker-compose up -d --build

wp-shell:
	docker exec -it wordpress /bin/sh

db-shell:
	docker exec -it mariadb /bin/sh

nginx-shell:
	docker exec -it nginx /bin/sh

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
