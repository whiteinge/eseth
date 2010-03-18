# -*- coding: utf-8 -*-
import sys, os

sys.path.append(os.path.abspath('./ext'))
extensions = ['rcfile', 'feed']

project = u'Esoteric Rubbish'
copyright = u'2009, Nathaniel Whiteinge'

version = '1.0'
release = '1.0'
pygments_style = 'sphinx'
templates_path = ['templates']
source_suffix = '.rst'
master_doc = 'index'

rc_url = 'http://bitbucket.org/whiteinge/dotfiles/src'

base_uri = "http://eseth.org/"
feed_title = project
feed_description = "Rambling so bereft of purpose it will change your religion"
feed_link = base_uri + 'rss.xml'

html_title = "Esoteric Rubbish"
#html_logo = None
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
