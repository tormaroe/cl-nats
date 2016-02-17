
![cl-nats logo](https://github.com/tormaroe/cl-nats/blob/master/images/cl-nats-logo.png)

# NATS - Common Lisp Client

A Common Lisp client for the [NATS messaging system](https://nats.io/).

[![License MIT](https://img.shields.io/npm/l/express.svg)](http://opensource.org/licenses/MIT) ![Alpha](https://img.shields.io/badge/project%20state-alpha-red.svg)

**THE LIBRARY IS UNDER DEVELOPMENT, NOT READY TO BE USED, SOME PARTS NOT YET WORKING**

## Installation

cl-nats is not available through quicklisp yet, so clone this repository to some location where quicklisp can find it, and then run:

    (ql:quickload :cl-nats)

## Basic Usage

    (defvar conn (nats:make-connection))

    ;; Simple Subscriber
    (nats:publish conn "foo" "Hello World!")

    ;; Simple Subscriber
    (nats:subscribe conn "foo"
      (lambda (msg)
        (format t "Received a message: ~S~%" msg)))

    ;; Unsubscribing
    (defvar sid (nats:subscribe conn "foo"
                  (lambda (msg)
                    (declare (ignore msg)))))
    (nats:unsubscribe conn sid)

    ;; Close connection
    (nats:close conn)

## API

### Package NATS

#### function MAKE-CONNECTION (&key host port name)

Connect to a NATS daemon running on `host:port` (default 127.0.0.1:4222) and return an object of type `nats.connection:connection`. The optional `name` is sent to NATS to identify the client.

#### function CONNECT (connection)

...

#### function SUBSCRIBE (connection subject handler &key queue-group)

...

#### function UNSUBSCRIBE (connection sid &key max-wanted)

...

#### function PUBLISH (connection subject message)

...

#### function REQUEST (connection subject handler)

...

#### function DISCONNECT (connection)

...

#### macro WITH-CONNECTION ((connection &key host port) &body body)

...

### Package NATS.VARS

#### special variable *HOST*

The NATS server IP, defaults to `#(127 0 0 1)`.

#### special variable *PORT*

The NATS server TCP/IP port, defaults to `4222`.

#### special variable *CLIENT-NAME*

The client name sent to the NATS server, defaults to empty string.

#### special variable *ENCODING*

The FLEXI-STREAMS charachter encoding to use when communicating with NATS, defaults to `:utf8`.

## License

(The MIT License)

Copyright (c) 2016 Torbjørn Marø

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.