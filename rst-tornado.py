# -*- coding: utf-8 -*-
"""Simple blog application. Transform and serve RestructuredText files.

"""
import os

import tornado.httpserver
import tornado.ioloop
import tornado.web

from docutils.core import publish_string

import uimodules

PORT = 8888
RST_PATH = 'content' or os.path.dirname(__file__)
RST_EXT = '.rst'

# TODO (fast):
# parse directory for .rst files
# parse filenames for publish date and slug
# TODO (slow):
# parse individual .rst files for tags and headings
# serve memoized .html files or generate on the fly (and use memcache/redis/squid)?

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        entries = []
        self.render('index.html', entries=entries)

class EntryHandler(tornado.web.RequestHandler):
    def get(self, entry_id):
        filename = 'content/2009-11-20_neatx-love.rst'
        rst = open(filename).read()
        entry = publish_string(rst, writer_name='html')

        if not entry:
            raise tornado.web.HTTPError(404)

        self.render('entry.html', entry=entry)


settings = {
    # 'blog_title': u'Esoteric Rubbishes',
    'blog_title': u'Insane Ramblings from an Inane Person',
    'ui_modules': uimodules,
    'static_path': os.path.join(RST_PATH, 'static'),
    'template_path': os.path.join(RST_PATH, 'templates'), 
}

application = tornado.web.Application([
    (r'/', MainHandler),
    (r'/entry/([0-9]+/)', EntryHandler),
    (r'/entry/([0-9]+/feed/)', EntryHandler),
], **settings)

if __name__ == '__main__':
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(PORT)
    tornado.ioloop.IOLoop.instance().start()
