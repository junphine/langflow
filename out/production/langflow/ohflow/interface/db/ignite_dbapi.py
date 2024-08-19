from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import logging

import pyignite
from sqlalchemy.exc import SQLAlchemyError as Error, DisconnectionError, ResourceClosedError, NoResultFound, NotSupportedError

logger = logging.getLogger(__name__)

paramstyle = 'qmark'


def connect(*cargs, **cparams):
    return Connection(*cargs, **cparams)


def check_closed(f):
    """Decorator that checks if connection/cursor is closed."""

    def g(self, *args, **kwargs):
        if self.closed:
            raise ResourceClosedError(
                '{klass} already closed'.format(klass=self.__class__.__name__))
        return f(self, *args, **kwargs)

    return g


def check_result(f):
    """Decorator that checks if the cursor has results from `execute`."""

    def d(self, *args, **kwargs):
        if self._results is None:
            raise NoResultFound('Called before `execute`')
        return f(self, *args, **kwargs)

    return d

def authenticate_basic_token(uid,pwd):
    return 'BASIC_TOKEN: '+ uid+':'+pwd


class Connection(object):

    def __init__(self, *cargs, **cparams):

        # Build a map from the connection string supplied using the SQLAlchemy URI
        # and supplied properties. The format is generated from DremioDialect_flight.create_connect_args()
        # and is a semi-colon delimited string of key=value pairs. Note that the value itself can
        # contain equal signs.
        properties = {}
        connection_string = cargs[0]
        splits = connection_string.split(";")

        for kvpair in splits:
            kv = kvpair.split("=",1)
            properties[kv[0]] = kv[1]

        self.connection_args = cparams

        # Connect to the server endpoint with an encrypted TLS connection by default.

        client = pyignite.Client()
        client.connect(properties['HOST'], int(properties['PORT']))

        
        # Authenticate either using basic username/password or using the Token parameter.
        headers = []
        if 'UID' in properties:
            bearer_token = authenticate_basic_token(properties['UID'], properties['PWD'])
            headers.append((b'authorization', bearer_token))
        elif 'Token' in properties:
            headers.append((b'authorization', "Bearer {}".format(properties['Token']).encode('utf-8')))

        # Propagate Dremio-specific headers.
        def add_header(properties, headers, header_name):
            if header_name in properties:
                headers.append((header_name.lower().encode('utf-8'), properties[header_name].encode('utf-8')))

        add_header(properties, headers, 'Schema')
        add_header(properties, headers, 'Token')
        add_header(properties, headers, 'routing_tag')
        add_header(properties, headers, 'quoting')


        self.client = client
        self.options = dict(headers=headers)

        self.closed = False
        self.cursors = []

    @check_closed
    def rollback(self):
        pass

    @check_closed
    def close(self):
        """Close the connection now."""
        self.closed = True
        for cursor in self.cursors:
            try:
                cursor.close()
            except Exception:
                pass  # already closed
        self.client.close()

    @check_closed
    def commit(self):
        pass

    @check_closed
    def cursor(self):
        """Return a new Cursor Object using the connection."""
        cursor = Cursor(self.client, self.connection_args)
        self.cursors.append(cursor)

        return cursor

    @check_closed
    def execute(self, query, params=[]):
        cursor = self.cursor()
        return cursor.execute(query, params)

    def __enter__(self):
        return self

    def __exit__(self, *exc):
        self.commit()  # no-op
        self.close()


class Cursor(object):
    """Connection cursor."""

    def __init__(self, client=None, options=None):
        self.client = client
        self.options = options

        # This read/write attribute specifies the number of rows to fetch at a
        # time with .fetchmany(). It defaults to 1 meaning to fetch a single
        # row at a time.
        self.arraysize = 1

        self.closed = False

        # this is updated only after a query
        self.description = None

        # this is set to a list of rows after a successful query
        self._results = None

        self.lastrowid = None

    @property
    @check_result
    @check_closed
    def rowcount(self):
        print('###can not get rowcount')
        return -1 if self._results is None else -1

    def close(self):
        if not self.closed:
            self._results.close()
            self._results = None
            print('###close curser')
            """Close the cursor."""
            self.closed = True

    @check_closed
    def execute(self, query, params=None):
        field_result = []
        self._results = self.client.sql(query, query_args=params, include_field_names=True,**self.options)
        field_names = next(self._results)
        for x in field_names:
            o = (x, None, None, None, True)
            field_result.append(o)
        self.description = field_result
        return self

    @check_closed
    def executemany(self, query):
        raise NotSupportedError(
            '`executemany` is not supported, use `execute` instead')

    @check_result
    @check_closed
    def fetchone(self):
        """
        Fetch the next row of a query result set, returning a single sequence,
        or `None` when no more data is available.
        """
        try:
            return next(self._results)
        except StopIteration:
            return None

    @check_result
    @check_closed
    def fetchmany(self, size=None):
        """
        Fetch the next set of rows of a query result, returning a sequence of
        sequences (e.g. a list of tuples). An empty sequence is returned when
        no more rows are available.
        """
        size = size or self.arraysize
        out = []
        for i in range(size):
            out.append(next(self._results))
        return out

    @check_result
    @check_closed
    def fetchall(self):
        """
        Fetch all (remaining) rows of a query result, returning them as a
        sequence of sequences (e.g. a list of tuples). Note that the cursor's
        arraysize attribute can affect the performance of this operation.
        """
        out = list(self._results)
        return out

    @check_closed
    def setinputsizes(self, sizes):
        # not supported
        pass

    @check_closed
    def setoutputsizes(self, sizes):
        # not supported
        pass

    @check_closed
    def __iter__(self):
        return self._results
