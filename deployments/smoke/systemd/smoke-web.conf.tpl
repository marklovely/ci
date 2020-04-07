[Service]
Environment=CONCOURSE_SESSION_SIGNING_KEY=/etc/concourse/session_signing_key
Environment=CONCOURSE_TSA_HOST_KEY=/etc/concourse/host_key
Environment=CONCOURSE_TSA_AUTHORIZED_KEYS=/etc/concourse/authorized_worker_keys
%{ if use_https ~}
AmbientCapabilities=CAP_NET_BIND_SERVICE
Environment=CONCOURSE_EXTERNAL_URL=https://${instance_ip}.xip.io
Environment=CONCOURSE_TLS_BIND_PORT="443"
Environment=CONCOURSE_ENABLE_LETS_ENCRYPT="true"
Environment=CONCOURSE_LETS_ENCRYPT_ACME_URL=https://acme-staging-v02.api.letsencrypt.org/directory
%{ else ~}
Environment=CONCOURSE_EXTERNAL_URL=http://${instance_ip}:8080
%{ endif ~}
Environment=CONCOURSE_POSTGRES_USER=concourse
Environment=CONCOURSE_POSTGRES_DATABASE=concourse
Environment=CONCOURSE_POSTGRES_SOCKET=/var/run/postgresql
Environment=CONCOURSE_ADD_LOCAL_USER=admin:${admin_password},guest:${guest_password}
Environment=CONCOURSE_MAIN_TEAM_LOCAL_USER=admin
Environment=CONCOURSE_CLIENT_SECRET=${client_secret}
Environment=CONCOURSE_TSA_CLIENT_SECRET=${tsa_client_secret}
