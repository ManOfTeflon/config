import actions
import argparse

class _ActionMeta(type):
    def __call__(cls, func):
        o = object.__new__(cls)
        o.__init__()
        return o(func)

class Context(object):
    def __init__(self, **kwargs):
        self._subparsers = None
        self._actions = []
        self._parent_parser = argparse.ArgumentParser(add_help=False)
        self._context = self
        self._parent_parser.add_argument('--', action='store_true', dest='__')
        for name, arg in kwargs.iteritems():
            arg._modify(name)
            arg._add(self._parent_parser)

        context = self
        class _Action(actions.ActionBase):
            __metaclass__ = _ActionMeta

            def __init__(self):
                actions.ActionBase.__init__(self, context)

            def __call__(self, func):
                func = actions.ActionBase.__call__(self, func)
                context._register_action(self)
                return func
        self.Action = _Action

        class _Main(_Action):
            def __call__(self, func):
                func = actions.ActionBase.__call__(self, func)
                context.main = self
                return func
        self.Main = _Main

        self.main = None
        self._parser = None

    def __getattr__(self, attr):
        return getattr(self.main, attr)

    def _register_action(self, action):
        self._actions.append(action)
        setattr(self, action.get_name(), action)

    def execute(self, *args, **kwargs):
        try:
            options = self._get_parser().parse_args(*args, **kwargs)
        except SystemExit as e:
            if int(str(e)):
                raise actions.ParseError()
            else:
                return

        if not hasattr(options, '__action'):
            setattr(options, '__action', self.get_full_name())
        self.global_arguments = options
        to_run = []
        action = self._context
        option_name = '__action'
        while hasattr(options, option_name):
            action_name = getattr(options, option_name)
            option_name = '%s.%s' % (option_name, action_name)
            action = getattr(action, action_name)
            to_run.append(action)

        for action in to_run:
            action._execute(options)

    def _get_parser(self, *args, **kwargs):
        if self._parser is None:
            self._build_parser()
        return self._parser

    def _build_parser(self):
        from __main__ import __doc__ as main_doc
        self._parser = argparse.ArgumentParser(description=main_doc, parents=[ self._parent_parser ])

        if self.main is None:
            @self.Main
            def main():
                pass
        self._add_arguments()

    def _add_arguments(self):
        self.main._parser = self._parser
        self.main._add_arguments()
        if self._actions:
            self._subparsers = self._parser.add_subparsers(dest='__action')
        for action in self._actions:
            action._build_parser()

