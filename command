sudo yum install -y https://download.postgresql.org/pub/repos/yum/16/redhat/rhel-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm


sudo yum -qy module disable postgresql

sudo yum install -y postgresql16 postgresql16-server postgresql16-contrib


sudo /usr/pgsql-16/bin/postgresql-16-setup initdb

sudo systemctl start postgresql-16
sudo systemctl enable postgresql-16

/usr/pgsql-16/bin/pgbench --version



sudo -u postgres createdb pgbench

sudo -u postgres /usr/pgsql-16/bin/pgbench -i pgbench


sudo -u postgres /usr/pgsql-16/bin/pgbench -c 10 -t 1000 pgbench


wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.10.0/postgres_exporter-0.10.0.linux-amd64.tar.gz


tar xvf postgres_exporter-0.10.0.linux-amd64.tar.gz


sudo mv postgres_exporter /usr/local/bin/
