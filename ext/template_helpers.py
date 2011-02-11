import datetime

from sphinx.jinja2glue import BuiltinTemplateLoader

def dayssince(date_obj):
    if isinstance(date_obj, str) or isinstance(date_obj, unicode):
        try:
            date_obj = datetime.datetime.strptime(date_obj, '%Y-%m-%d')
        except ValueError:
            return date_obj
    else:
        return date_obj

    now = datetime.datetime.now()
    return (now - date_obj).days

class BlogTemplateBridge(BuiltinTemplateLoader):
    """A TemplateBridge that adds some filters that are useful for blogging."""
    def init(self, *args, **kwargs):
        super(BlogTemplateBridge, self).init(*args, **kwargs)

        self.environment.filters['dayssince'] = dayssince
