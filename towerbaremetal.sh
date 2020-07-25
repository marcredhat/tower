wget https://releases.ansible.com/ansible-tower/setup-bundle/ansible-tower-setup-bundle-latest.tar.gz

tar -xvzf ansible-tower-setup-bundle-latest.tar.gz

cd ansible-tower-setup-bundle-3.7.1-1/

#change passwords in the inventory file (vi inventory)

./setup.sh 
