
#In /etc/nfsmount.conf:
#change Defaultvers=4 to Defaultvers=3



#Check latest Tower release at https://releases.ansible.com/ansible-tower/setup_openshift/
wget https://releases.ansible.com/ansible-tower/setup_openshift/ansible-tower-openshift-setup-3.7.1-1.tar.gz
oc new-project tower371
tar -xvzf ansible-tower-openshift-setup-3.7.1-1.tar.gz
cd ansible-tower-openshift-setup-3.7.1-1/roles/kubernetes/tasks/
rm -f main.yml
wget https://raw.githubusercontent.com/marcredhat/tower/master/main.yml
cd ../../..
ln -s /usr/bin/python3 /usr/bin/python


oc create -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgresql
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce
  nfs:
    path: /mnt/storage
    server: 10.1.8.11
  persistentVolumeReclaimPolicy: Retain
  storageClassName: non-dynamic
EOF



oc create -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgresql
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF


./setup_openshift.sh -e openshift_host=https://api.apps.ocp4.local:6443 -e openshift_project=tower371 -e openshift_user=marc -e openshift_password=marcz  -e admin_password=admin -e secret_key=mysecret -e pg_username=postgresuser -e pg_password=postgrespwd -e rabbitmq_password=rabbitpwd -e rabbitmq_erlang_cookie=rabbiterlangpwd -e openshift_skip_tls_verify=True

oc apply -f https://raw.githubusercontent.com/marcredhat/tower/master/towerdeployment.yml
