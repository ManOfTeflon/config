class Argument(object):
    def __init__(self, name=None, **kwargs):
        self.kwargs = {}
        self.args = []
        self._modify(name, **kwargs)

    def _modify(self, name, **kwargs):
        if isinstance(name, str) and 'dest' not in self.kwargs:
            self.kwargs['dest'] = name.replace('-', '_')
        self.kwargs = dict(self.kwargs, **kwargs)

        if name is not None:
            name = name.replace('_', '-').lstrip('-')
            self.args = [ '--' + name ]

            if 'short' in self.kwargs:
                self.args += [ '-' + c for c in self.kwargs['short'] ]

    def _add(self, parser):
        if 'short' in self.kwargs:
            del self.kwargs['short']
        parser.add_argument(*self.args, **self.kwargs)

    def __eq__(self, other):
        return other == None

class PositionalArgument(Argument):
    def _modify(self, name, **kwargs):
        self.kwargs = dict(self.kwargs, **kwargs)

        if name is not None:
            self.args = [ name ]
            name = name.replace('_', '-').lstrip('-')
            self.kwargs['metavar'] = name

    def _add(self, parser):
        if 'dest' in self.kwargs:
            del self.kwargs['dest']
        parser.add_argument(*self.args, **self.kwargs)
