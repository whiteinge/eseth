# -*- coding: utf-8 -*-
"""Hooks to generate RSS feeds for pages."""
from __future__ import with_statement # python 2.5 compat

import hashlib
import os

from xml.etree import ElementTree as etree

VERSION = '0.1.0'
AUTHOR = 'Seth House <seth@eseth.com>'

def indent(elem, level=0):
    i = "\n" + level*"  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for elem in elem:
            indent(elem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i

def create_feed(app):
    feed = etree.Element('rss', {'version': '2.0'})
    channel = etree.SubElement(feed, 'channel')
    etree.SubElement(channel, 'title').text = app.config.feed_title
    etree.SubElement(channel, 'link').text = app.config.feed_link
    etree.SubElement(channel, 'description').text = app.config.feed_description
    # etree.SubElement(channel, 'pubDate').text = ??
    # etree.SubElement(channel, 'lastBuildDate').text = ??

    app.builder.env.feed = etree.tostring(feed)

def create_items(app, pagename, templatename, ctx, doctree):
    """Iterate over each document."""
    if pagename.endswith('index') or pagename in ['search']:
        return

    feed = etree.fromstring(app.builder.env.feed)
    channel = feed.find('channel')

    item = etree.SubElement(channel, 'item')
    etree.SubElement(item, 'title').text = ctx.get('title')
    etree.SubElement(item, 'description').text = ctx.get('body')
    etree.SubElement(item, 'link').text = \
            app.config.base_uri + app.builder.get_target_uri(pagename)
    etree.SubElement(item, 'guid').text = \
            hashlib.sha1(ctx.get('body').encode('utf-8')).hexdigest()

    app.builder.env.feed = etree.tostring(feed)

def write_feed(app, exc):
    feed = etree.ElementTree(etree.fromstring(app.builder.env.feed))
    indent(feed.getroot())

    with open(os.path.join(app.builder.outdir, 'rss.xml'), 'w') as f:
        feed.write(f, 'utf-8')

def setup(app):
    app.add_config_value('feed_title', 'My RSS Feed', False)
    app.add_config_value('feed_link', 'http://example.com/feed/', False)
    app.add_config_value('feed_description', 'My nifty feed.', False)
    app.add_config_value('base_uri', 'http://example.com/', False)

    app.connect('builder-inited', create_feed)
    app.connect('html-page-context', create_items)
    app.connect('build-finished', write_feed)
