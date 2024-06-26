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




[Unit]
Description=PostgreSQL Exporter for Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=postgres
Group=postgres
Environment=DATA_SOURCE_NAME=postgresql://postgres_exporter:password@localhost:5432/postgres?sslmode=disable
ExecStart=/usr/local/bin/postgres_exporter
Restart=always

[Install]
WantedBy=multi-user.target




#############################################
GUN
#############################################
sudo tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF


sudo yum install grafana -y

sudo systemctl start grafana-server
sudo systemctl enable grafana-server



# nano /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt

sudo chown -R grafana:grafana /etc/grafana
sudo chown -R grafana:grafana /var/lib/grafana
sudo chown -R grafana:grafana /var/log/grafana



wget https://github.com/prometheus/alertmanager/releases/download/v0.23.0/alertmanager-0.23.0.linux-amd64.tar.gz

tar xvf alertmanager-0.23.0.linux-amd64.tar.gz

sudo mv alertmanager-0.23.0.linux-amd64/alertmanager /usr/local/bin/
sudo mv alertmanager-0.23.0.linux-amd64/amtool /usr/local/bin/

sudo mkdir /etc/alertmanager

sudo nano /etc/alertmanager/alertmanager.yml

sudo nano /etc/systemd/system/alertmanager.service


[Unit]
Description=Prometheus Alertmanager Service
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml
Restart=always

[Install]
WantedBy=multi-user.target

global:
  resolve_timeout: 5m

route:
  receiver: 'default-receiver'

receivers:
  - name: 'default-receiver'
    email_configs:
      - to: 'peerawit2010@gmail.com'
        from: 'alertmanager@example.com'
        smarthost: 'localhost:25'





[Unit]
Description=Prometheus Alertmanager Service
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --storage.path=/var/lib/alertmanager --log.level=debug
Restart=always

[Install]
WantedBy=multi-user.target



groups:
  - name: test_alert
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} down"
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute."



