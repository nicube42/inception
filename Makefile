up:
	docker-compose up -d

down:
	docker-compose down

rebuild:
	docker-compose up -d --build

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
