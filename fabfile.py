# -*- coding: utf-8 -*-
import os
import tempfile

import fabric
import fabric.api as _fab

_fab.env.roledefs = {
    'bishop': ['192.168.0.100'],
    'eseth': ['eseth.org']}

_fab.env.hosts = _fab.env.roledefs.get('bishop')
role = lambda x: _fab.env.roledefs.get(x)

def deploy(version='tip'):
    filename = 'esoteric_rubbish.tar.bz2'
    dest_path = 'esoteric_rubbish'

    tempdir = tempfile.mkdtemp()
    file = os.path.join(tempdir, filename)

    _fab.local('hg archive -r %s -t tbz2 %s' % file)
    _fab.put(file, dest_path)

    with _fab.cd(dest_path):
        _fab.run('./bin/sphinx-build . _build')
        # TODO: restart tornado
