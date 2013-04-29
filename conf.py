# -*- coding: utf-8 -*-
import sys, os

sys.path.append(os.path.abspath('./ext'))
extensions = ['rcfile', 'sphinxcontrib.feed']

project = u'Esoteric Rubbish'
copyright = u'2013, Seth House'

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

feed_base_url = "http://eseth.org"
feed_title = project
feed_description = "Rambling so utterly bereft of purpose"

html_title = "Esoteric Rubbish"
html_add_permalinks = False
html_favicon = 'favicon.ico'
html_static_path = ['static']
html_show_sourcelink = True
html_theme= 'default'
html_style = ['base-eseth.css', 'pygments.css']

latex_documents = [
  ('index', 'EsotericRubbish.tex', u'Esoteric Rubbish',
   u'Seth House', 'manual'),
]

man_pages = [
    ('index', 'eseth-org', project, 'Seth House', 1),
]
