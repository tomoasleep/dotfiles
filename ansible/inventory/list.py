#!/usr/bin/env python3

import sys
import json

def get_localhost_group:
  skip

def get_list:
  return {
    get_localhost_group() => {
      'hosts': ['localhost'],
    }
  }


if sys.argv[1] == '--list':
  print(json.dumps(get_list()))
  print(json.dumps({})
else:
