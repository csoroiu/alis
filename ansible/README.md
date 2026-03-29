# Ansible Inventory Hosts File

This file defines the inventory for Ansible playbooks in this project.


## Prerequisites
- Ansible installed on your control machine. For installation instructions, see the [Ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- Install ask-pass dependencies. For Debian/Ubuntu:
  ```shell
  sudo apt-get install sshpass
  ```
  For Red Hat/CentOS:
  ```shell
  sudo yum install sshpass
  ```
  For Arch Linux:
  ```shell
  sudo pacman -S sshpass
  ```
  For Alpine Linux:
  ```shell
  apk add sshpass
  ```
  
- **community.openwrt** collection installed. You can install it using:
  ```shell
  ansible-galaxy collection install community.openwrt
  ```

## Running the Install OpenWRT Packages Playbook for the First Time

To set up an OpenWRT host for the first time, run the `install-openwrt-packages.yaml` playbook. This installs Python3 (required for Ansible), additional packages (etherwake, usbutils, usteer, luci-app-usteer), and sets up SSH key authentication.

Use the following command, replacing `<group>` with the target group or host (e.g., `tl_wr1043nd` or `192.168.1.1`):

```shell
ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' --ask-pass -l <group> install-openwrt-packages.yaml
```

- `--ssh-common-args='-o StrictHostKeyChecking=no'`: Disables SSH host key checking to allow password auth without known_hosts.
- `--ask-pass`: Prompts for the SSH password.
- `-l <group>`: Limits the run to the specified group or host.

After the first successful run, you can connect using SSH keys without `--ask-pass` for future playbooks.

Alternatively, you can run first step manually to install python3 using the `raw` module, then run the playbook without `--ask-pass`:

```shell
ansible --ssh-common-args='-o StrictHostKeyChecking=no' <group> -m raw -a "apk update; apk add python3" --ask-pass
ansible-playbook -l <group> install-openwrt-packages.yaml
```