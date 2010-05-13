# -*- coding: utf-8 -*-
"""Fabric script for Esoteric Rubbish."""
import os
import shutil
import tempfile

import fabric
import fabric.api as _fab

##### Environment
###############################################################################
_fab.env.roledefs = {
    'local': ['192.168.0.100'],
    'web': ['bishop.eseth.org'],
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

    # First prime sudo so the below call doesn't prompt for a password
    _fab.sudo('echo GNDN')

    _fab.local('rsync -pthrvz --rsync-path="sudo rsync" '\
            '--chmod=u=rwX,go=rX --no-owner --no-group '\
            '--delete '\
            '%(tempdir)s/ bishop.eseth.org:/srv/httpd/eseth.org' % locals())

    # clean up
    shutil.rmtree(tempdir)
