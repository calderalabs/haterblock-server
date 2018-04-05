#! /usr/bin/env python2

import json
import os
import re
import subprocess
import sys

TERRAFORM_PATH = os.environ.get('ANSIBLE_TF_BIN', 'terraform')
TERRAFORM_DIR = os.environ.get('ANSIBLE_TF_DIR', os.getcwd())

def _inventory(state):
  root_module = filter(lambda m: m['path'][0] == 'root', state['modules'])[0]
  host = root_module['outputs']['public_ip']['value']

  return {
    'web': {
      'hosts': [host]
    },
    'packer': {
      'hosts': ['127.0.0.1']
    },
    '_meta': {
      'hostvars': {
        host: {
          'ansible_user': 'ubuntu',
          'ansible_ssh_private_key_file': os.environ.get('SSH_PRIVATE_KEY_FILE')
        }
      }
    }
  }

def _main():
  try:
    tf_command = [TERRAFORM_PATH, 'state', 'pull', '-input=false']
    proc = subprocess.Popen(tf_command, cwd=TERRAFORM_DIR, stdout=subprocess.PIPE)
    tfstate = json.load(proc.stdout)
    inventory = _inventory(tfstate)
    sys.stdout.write(json.dumps(inventory, indent=2))
  except:
    sys.exit(1)

if __name__ == '__main__':
  _main()
