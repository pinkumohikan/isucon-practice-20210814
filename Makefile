.PHONY: gogo build stop-services start-services truncate-logs kataribe bench

gogo: stop-services build truncate-logs start-services bench

build:
	make -C webapp/go isuumo

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop isuumo.go
	sudo systemctl stop mysql

start-services:
	sudo systemctl start mysql
	sleep 5
	sudo systemctl start isuumo.go
	sudo systemctl start nginx

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /var/log/mysql/error.log
	sudo truncate --size 0 /var/log/mysql/mysql-slow.log

kataribe:
	sudo cat /var/log/nginx/access.log | ./kataribe

bench:
	cd /home/isucon/isuumo/bench && ./bench -target-url=http://localhost:80
