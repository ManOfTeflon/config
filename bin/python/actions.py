import argparse
import inspect
import collections

from context import Context
from arguments import Argument, PositionalArgument

class ParseError(Exception):
    pass

class _Arguments(dict):
    def __getattr__(self, attr):
        return self[attr]

    def __setattr__(self, attr, value):
        self[attr] = value

class ActionBase(Context):
    def __init__(self, parent, frame_num=0):
        Context.__init__(self)
        self._parent = parent
        self._arguments = collections.OrderedDict()
        self._parent_parser = parent._parent_parser
        self._context = parent._context
        self._frame_num = frame_num

    def __call__(self, func):
        self._frame = inspect.stack()[3 + self._frame_num][0]
        self._func_name = func.__name__
        self._func_doc = func.__doc__

        self._args, self._varargs, self._keywords, self._defaults = inspect.getargspec(func)
        defaults = [] if self._defaults is None else self._defaults
        no_default = {}
        defaults = [ no_default ] * (len(self._args) - len(defaults)) + list(defaults)

        for arg, default in zip(self._args, defaults):
            self._arguments[arg] = Argument(arg)
            if isinstance(default, Argument):
                default._modify(arg, dest=arg)
                self._arguments[arg] = default
            elif default is no_default:
                self._arguments[arg] = Argument(arg)
            else:
                self._arguments[arg] = Argument(arg, default=default)
        if self._varargs is not None:
            self._arguments[self._varargs] = PositionalArgument(self._varargs, nargs=argparse.REMAINDER)
        return func

    def __execute(self, *args, **kwargs):
        return dict(self._frame.f_globals, **self._frame.f_locals)[self._func_name](*args, **kwargs)

    def get_name(self):
        return self._func_name

    def get_full_name(self):
        names = []
        action = self
        while isinstance(action, ActionBase):
            names.insert(0, action.get_name())
            action = action._parent
        return '.'.join(names)

    def _execute(self, options):
        kwargs = vars(options).copy()
        if '__action' in kwargs:
            del kwargs['__action']

        try:
            self.arguments = _Arguments({ arg: kwargs[arg] for arg in self._args })
        except KeyError:
            import traceback
            traceback.print_exc()
            raise ParseError()
        args = [ kwargs[arg] for arg in self._args ]
        for arg in self._args:
            del kwargs[arg]

        if self._varargs is not None and self._varargs in kwargs.keys():
            self.varargs = list(kwargs[self._varargs])
            if self.varargs[:1] == ['--']:
                self.varargs = self.varargs[1:]
            args += list(self.varargs)
            del kwargs[self._varargs]

        self.return_value = self.__execute(*args)

    def _build_parser(self):
        self._parser = self._parent._subparsers.add_parser(self._func_name, help=self._func_doc, parents=[ self._parent_parser ])

        self._add_arguments()

    def _add_arguments(self):
        for arg in self._arguments.itervalues():
            arg._add(self._parser)
        if self._actions:
            self._subparsers = self._parser.add_subparsers(dest='__action.' + self.get_full_name())
        for action in self._actions:
            action._build_parser()

__context = Context()
Action = __context.Action
Main = __context.Main

def execute(*args, **kwargs):
    __context.execute(*args, **kwargs)

