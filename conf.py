# -*- coding: utf-8 -*-
import sys, os, datetime

sys.path.append(os.path.abspath('./ext'))
extensions = ['rcfile', 'feed']

project = u'Esoteric Rubbish'
copyright = u'2009, Seth House'

version = '1.0'
release = '1.0'

master_doc = 'index'
source_suffix = '.rst'

pygments_style = 'sphinx'
templates_path = ['templates']
template_bridge = 'template_helpers.BlogTemplateBridge'

rc_url = 'http://github.com/whiteinge/dotfiles/blob'
rc_head = 'master'
rc_linenr = '#L%(linenr)s'
rc_main = 'http://github.com/whiteinge/dotfiles/tree/master'

base_uri = "http://eseth.org"
feed_title = project
feed_description = "Rambling so utterly bereft of purpose"
feed_link = '%s/rss.xml' % (base_uri,)
feed_maxitems = 7
feed_ignorepagenames = ['index_*', 'search']

html_title = "Esoteric Rubbish"
html_logo = 'static/whiteinge.jpg'
html_add_permalinks = False
html_favicon = 'favicon.ico'
html_static_path = ['static']
html_show_sourcelink = True
html_theme= 'default'
html_theme_options = {
    'rightsidebar': 'true',

    'footerbgcolor': '#000',
    'footertextcolor': 'whiteSmoke',
    'sidebarbgcolor': 'whiteSmoke',
    'sidebartextcolor': '#555',
    'sidebarlinkcolor': '#a7a7a7',
    'relbarbgcolor': 'whiteSmoke',
    'relbartextcolor': '#555',
    'relbarlinkcolor': '#a7a7a7',
    'bgcolor': 'whiteSmoke',
    'textcolor': '#555',
    'linkcolor': '#a7a7a7',
    'headbgcolor': 'whiteSmoke',
    'headtextcolor': '#555',
    'headlinkcolor': '#a7a7a7',
    'codebgcolor': '#FBFAF4',
    'codetextcolor': '#333',

    'bodyfont': '"helvetica neue", arial, sans-serif',
    'headfont': '"helvetica neue", arial, sans-serif',
}

latex_documents = [
  ('index', 'EsotericRubbish.tex', u'Esoteric Rubbish',
   u'Seth House', 'manual'),
]

man_pages = [
    ('index', 'eseth-org', project, 'Seth House', 1),
]
