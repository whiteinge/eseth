# -*- coding: utf-8 -*-
"""Fabric script for Esoteric Rubbish."""
import os
import tempfile

import fabric
import fabric.api as _fab


##### Environment
###############################################################################
_fab.env.roledefs = {
    'local': [],
    'web': ['eseth.org'],
}
_fab.env.hosts = _fab.env.roledefs['local']

def production():
    """Make changes on the production server !

    This must be called in order to make changes to a host other than
    localhost.

    """
    _fab.env.hosts = _fab.env.roledefs['web']

def deploy():
    tempdir = os.path.join(tempfile.mkdtemp(), 'htdocs')
    _fab.local('sphinx-build -b dirhtml . %s' % tempdir)

    fabric.contrib.project.rsync_project(
            remote_dir='/home/shouse/',
            local_dir=tempdir,
            delete=True)
