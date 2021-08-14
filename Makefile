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
	ssh isucon@18.182.58.153 "cd /home/isucon/isuumo/bench && ./bench -target-url=http://18.179.17.66"

save-log: TS=$(shell date "+%Y%m%d_%H%M%S")
save-log: 
	mkdir /home/isucon/logs
	mkdir /home/isucon/logs/$(TS)
	sudo  cp -p /var/log/nginx/access.log  /home/isucon/logs/$(TS)/access.log
	sudo  cp -p /var/log/mysql/mysql-slow.log  /home/isucon/logs/$(TS)/mysql-slow.log
	sudo chmod -R 777 /home/isucon/logs/*
sync-log:
	scp -C kataribe.toml ubuntu@18.181.238.145:~/
	rsync -av -e ssh /home/isucon/logs ubuntu@18.181.238.145:/home/ubuntu  
analysis-log:
	ssh ubuntu@18.181.238.145 "sh push_github.sh"
gogo-log: save-log sync-log analysis-log
