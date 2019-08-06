#!/bin/bash
#===============================================================================
#
#          FILE:  install.sh
#
#         USAGE:  ./install.sh
#
#   DESCRIPTION:  Install Quipucords server and command-line components.
#
#       OPTIONS:  -h | --help   Obtain command USAGE
#                 -e | --extra-vars  set additional variables as key=value
#===============================================================================

export PATH=$PATH:$ANSIBLE_HOME/bin
PLAYBOOKFILE="qpc_playbook.yml"
POSTGRES_VERSION='-e POSTGRES_VERSION=9.6.10'
INSTALLER_VERSION='BUILD_VERSION_PLACEHOLDER'

declare -a args
args=("$*")
args+=("$POSTGRES_VERSION")
set -- ${args[@]}

usage() {
    cat <<EOM
    Quipucords Installer
    Version: ${INSTALLER_VERSION}

    Install Quipucords server and command-line components.

    Usage:
    $(basename $0)

    Options:
    -h | --help   Obtain command USAGE
    -e | --extra-vars  set additional variables as key=value


    Extra Variables:
    * Skip install for server:
         -e install_server=false
    * Skip install for CLI:
         -e install_cli=false
    * Perform an offline install
         -e install_offline=true
    * Quipucords server version to install (defaults to the latest release):
         -e server_version=0.0.46
    * QPC cli version to install (defaults to the latest release):
         -e cli_version=0.0.46
    * Specify if the Quipucords server port should be opened in the host firewall (defaults to true):
         -e open_port=false
    * Quipucords server port (defaults to 9443):
         -e server_port=8443
    * Postgres db user (defaults to 'postgres'):
         -e dbms_user=postgres
    * Postgres db password (defaults to 'password')
         -e dbms_password=password
EOM
    exit 0
}

if [[ ($1 == "--help") ||  ($1 == "-h") ]]
then
  usage;
fi

if [ ! -f /etc/redhat-release ]; then
  echo "/etc/redhat-release not found. You need to run this on a Red Hat based OS."
  exit 1
fi

PKG_MGR=yum
if grep -q -i "release 7" /etc/redhat-release; then
  dist="el7"
  if grep -q -i "Red Hat" /etc/redhat-release; then
    RHEL7=true
  fi
elif grep -q -i "release 6" /etc/redhat-release; then
  dist="el6"
fi

for arg in $args; do
  if [[ $arg != "-e" ]]; then
    IFS='=' read -r -a temp_arr <<< "$arg"
    key=${temp_arr[0]}
    value=${temp_arr[1]}
    printf -v $key "$value"
  fi
done

if [[ ($RHEL7) && (-z "$install_offline") ]] || [[ ($RHEL7) && ($install_offline = "false") ]]; then
  echo "Trying to install RHEL7 dependencies..."
  sudo subscription-manager repos --enable="rhel-7-server-extras-rpms" || true
  sudo subscription-manager repos --enable="rhel-7-server-optional-rpms" || true
fi

echo "Checking if ansible is installed..."
command -v ansible > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Ansible prerequisite could not be found. Trying to install ansible..."
  if [[ ($dist == "el7") || ($dist == "el6") ]]; then
    sudo "${PKG_MGR}" install -y ansible
  else
    sudo subscription-manager repos --enable="rcm-tools-rhel-8-baseos-rpms" || true
    sudo subscription-manager repos --enable="rcm-tools-rhel-8-appstream-rpms" || true
    sudo subscription-manager repos --enable ansible-2.8-for-rhel-8-x86_64-rpms || true
    sudo "${PKG_MGR}" install -y ansible || true
  fi
  
  command -v ansible > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo ""
    echo "Installation failed. Ansible prerequisite could not be installed."
    echo "Follow installation documentation for installing Ansible."
    unset args
    exit 1
  fi
fi

if [[ $EUID -ne 0 ]]
then
  echo ansible-playbook $PLAYBOOKFILE -v -K $*
  ansible-playbook $PLAYBOOKFILE -v -K $*
else
  echo ansible-playbook $PLAYBOOKFILE -v $*
  ansible-playbook $PLAYBOOKFILE -v $*
fi

if [ $? -eq 0 ]
then
  unset args
  echo "Installation complete."
else
  unset args
  echo "Installation failed. Review the install logs."
  exit 1
fi
