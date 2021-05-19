
#!/bin/bash

if [ -z "$1" ] ; then
  echo "$0 <playbook>"
  echo "(without play_ and .yml)"
  exit 1
fi
playbook="$1"
shift

echo "######## applying the playbook '$playbook' ########"
exec ansible-playbook -b -v play_$playbook.yml


