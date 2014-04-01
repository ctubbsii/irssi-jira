#! /usr/bin/env python
import urllib
import json
from sys import stdout,stderr
class Site:
  def __init__(self, name, url):
    self.name = name
    self.url = url

sites = [
    Site('Apache','https://issues.apache.org/jira'),
    Site('Codehaus','http://jira.codehaus.org')
    ]

def comp(a, b):
  return cmp(a['key'], b['key'])

for s in sites:
  f = urllib.urlopen(s.url + '/rest/api/2/project')
  projects = json.loads(f.read())
  f.close()
  projects.sort(comp)
  keys = 'my $'+s.name+'_JIRA_keys = qr/'
  kdelim = ''
  proj = 'my %'+s.name+'_JIRA_projects = ('
  pdelim = ''
  arr = 'my @projects = ('
  for p in projects:
    keys = keys + kdelim + p['key']
    proj = proj + pdelim + '"' + p['key'] + '", "' + p['name'] + '"'
    arr = arr + pdelim + "'" + p['key'] + "'"
    kdelim = '|'
    pdelim = ', '
  keys = keys + '/i;'
  proj = proj + ');'
  arr = arr + ');'
  print keys
  print proj
  print arr
