# -*- coding: utf-8 -*-
"""Hooks to generate RSS feeds for pages."""
import datetime
import hashlib
import os
import re
import sys

from xml.etree import ElementTree as etree

from docutils import nodes
import dateutil.parser

VERSION = '0.1.2'
AUTHOR = 'Seth House <seth@eseth.com>'

def indent(elem, level=0):
    """Make the output XML pretty."""
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
    """Create initial XML object and stuff it into the Sphinx builder env."""
    feed = etree.Element('rss', {'version': '2.0'})
    channel = etree.SubElement(feed, 'channel')
    etree.SubElement(channel, 'title').text = app.config.feed_title
    etree.SubElement(channel, 'link').text = app.config.feed_link
    etree.SubElement(channel, 'description').text = app.config.feed_description
    # etree.SubElement(channel, 'pubDate').text = ??
    # etree.SubElement(channel, 'lastBuildDate').text = ??

    app.builder.env.feed = etree.tostring(feed)

def create_items(app, pagename, templatename, ctx, doctree):
    """Iterate over each document and add it to the XML object."""
    # Remove unwanted pages
    for i in app.config.feed_ignorepagenames:
        if re.search(i, pagename):
            # app.builder.warn("Not including %(pagename)s in RSS feed." % locals())
            return

    # Remove pages without date published metadata
    # FIXME: please, please, please tell me there is a better way to fetch the
    # docinfo items. this is a fucking trainwreck
    if doctree:
        section = [i for i in doctree if isinstance(i, nodes.section)]
    else:
        section = []

    if section:
        field_list = [i for i in section[0] if isinstance(i, nodes.field_list)]
    else:
        field_list = []

    datestring = ''
    for field in field_list:
        for i in field:
            if i[0].astext() == app.config.feed_metadate:
                datestring = i[1].astext()

    if not datestring:
        # app.builder.warn("No datestring for %(pagename)s." % locals())
        return

    # Remove pages with un-parsable dates
    try:
        pubdate = dateutil.parser.parse(datestring)
    except ValueError, e:
        exc_info=sys.exc_info()

        app.builder.warn("""\
            Could not parse date: %(datestring)s in %(pagename)s
            %(exc_info)s
            """ % locals())

        return

    # Remove pages that are too old
    if app.config.feed_maxage:
        if pubdate < (datetime.datetime.now() - app.config.feed_maxage):
            # app.builder.warn("Pubdate is too old for inclusion in RSS feed for %(pagename)s." % locals())
            return

    feed = etree.fromstring(app.builder.env.feed)
    channel = feed.find('channel')

    item = etree.SubElement(channel, 'item')
    etree.SubElement(item, 'title').text = ctx.get('title')
    etree.SubElement(item, 'description').text = ctx.get('body')
    etree.SubElement(item, 'pubDate').text = pubdate.isoformat()
    etree.SubElement(item, 'link').text = "%s/%s" % (
            app.config.base_uri, app.builder.get_target_uri(pagename))
    etree.SubElement(item, 'guid').text = hashlib.sha1(
            ctx.get('body').encode('utf-8')).hexdigest()

    app.builder.env.feed = etree.tostring(feed)

def write_feed(app, exc):
    """Sort the items of the XML object and write it to a file."""
    feed = etree.ElementTree(etree.fromstring(app.builder.env.feed))
    indent(feed.getroot())

    # Sort the entries by date
    # http://effbot.org/zone/element-sort.htm
    container = feed.find('channel')
    container[:] = sorted(container, key=lambda i: i.findtext('pubDate'), reverse=True)

    # Truncate feed by maxitems
    if app.config.feed_maxitems:
        container[:] = container[:app.config.feed_maxitems]

    with open(os.path.join(app.builder.outdir, 'rss.xml'), 'w') as f:
        feed.write(f, 'utf-8')

def setup(app):
    app.add_config_value('feed_title', 'My RSS Feed', False)
    app.add_config_value('feed_link', 'http://example.com/feed/', False)
    app.add_config_value('feed_description', 'My nifty feed.', False)
    app.add_config_value('base_uri', 'http://example.com/', False)
    app.add_config_value('feed_maxitems', 0, False)
    app.add_config_value('feed_maxage', None, False) # a timedelta object
    app.add_config_value('feed_metadate', 'Date', False)
    app.add_config_value('feed_ignorepagenames', ['search'], False)

    app.connect('builder-inited', create_feed)
    app.connect('html-page-context', create_items)
    app.connect('build-finished', write_feed)
