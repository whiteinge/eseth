import tornado.web

class Entry(tornado.web.UIModule):
    def render(self, entry, show_comments=False):
        return self.render_string(
            'module-entry.html', show_comments=show_comments)

