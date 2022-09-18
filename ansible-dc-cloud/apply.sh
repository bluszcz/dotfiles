#!/bin/sh
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yaml -u ubuntu -i "$1,"
