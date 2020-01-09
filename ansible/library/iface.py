#!/bin/python3

from subprocess import Popen, PIPE
from ansible.module_utils.basic import AnsibleModuletime

ANSIBLE_METADATA = {
  'metadata_version': '1',
  'status': ['preview'],
  'supported_by': 'epava1516'
}

DOCUMENTATION = '''
---
module: iface

description: Interface status manager
'''

EXAMPLES = '''
# Start a interface
- name: Interface up
  iface:
    name: ens33
    state: started

# Stop a interface
- name: Interface down
  iface:
    name: ens33
    state: stopped

# Restart a interface
- name: Interface restart
  iface:
    name: ens33
    state: restarted
'''


class InterfaceManager:

  def __init__(self, interface):
    self.interface = interface
    self.status = []
    self.__monitor()

  def __monitor(self):
    p = Popen("ip a s {}".format(self.interface), shell=True, stdout=PIPE)
    while p.poll() is None:
      l = p.stdout.readline()
      print(l)
    self.status.append(p.stdout.read())

  def stopInterface(self):
    my_cmd = "ifdown {}".format(self.interface)
    p = Popen(my_cmd, shell=True, stdout=PIPE)
    p.wait()
    self.__monitor()

  def startInterface(self):
    my_cmd = "ifup {}".format(self.interface)
    p = Popen(my_cmd, shell=True, stdout=PIPE)
    p.wait()
    self.__monitor()

  def restartInterface(self):
    my_cmd = "ifdown {0} && ifup {0}".format(self.interface)
    p = Popen(my_cmd, shell=True, stdout=PIPE)
    p.wait()
    self.__monitor()


def run_module():
  module_args = dict(
  name=dict(required=True, type='str'),
  state=dict(required=True, type='str', choices=['started', 'stopped', 'restarted'])
  )

  result = dict(
        changed=False,
        original_message='',
        message=''
  )

  module = AnsibleModule(
          argument_spec=module_args,
          supports_check_mode=True
  )

  iface = InterfaceManager(module.params['name'])
  
  if module.params['state'] == 'started':
    iface.startInterface()
  elif module.params['state'] == 'stopped':
    iface.stopInterface()
  elif module.params['state'] == 'restarted':
    iface.restartInterface()

  if iface.status[0] == iface.status[1]:
    result['changed'] = False
  else:
    result['changed'] = True

  module.exit_json(**result)


def main():
    run_module()

if __name__ == '__main__':
    main()