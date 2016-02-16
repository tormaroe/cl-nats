
cl-nats
=======

Build a Common Lisp client library for [NATS](http://nats.io).

## Prep:

* Read http://nats.io/documentation/internals/nats-guide/
* Look at similar client libraries in Common Lisp for idioms and inspiration (cl-redis (including the pub/sub API), cl-beanstalk).
* Look at NATS client libs for other languages (node, ruby, C#)
* Read NATS blog to get into the mood
* Read up on CL socket lib (usocket)

## Start:

* System should be "cl-nats", but main package should be just "nats", right?
* Try it out with client in other language, use vagrant (or docker? or both??)
* Try out some NATS monitoring tool (nats-topm natsboard, nats-mon)
* Do a Ziptalk at work on NATS
* Implement cl-nats (look to other clients and protocol spec)
* Use unit tests (string as stream)
* Think about Common Lisp-spesific features like s-expr serialization

## QA:

* Integration test project, complex scenario tests, use Corona (cl vagrant)
* Get feedback from community
* Write README
  * See github badges here: https://github.com/fukamachi/clack
    * https://travis-ci.org (https://github.com/luismbo/cl-travis)
    * https://coveralls.io/ (https://github.com/fukamachi/cl-coveralls)
* Write blog post

## Stable:

* Set version number
* Master should now be stable
* Get client listed at nats.io
* Get client included in Quicklisp (stable branch ?)
  * http://blog.quicklisp.org/2015/01/getting-library-into-quicklisp.html
  * http://blog.quicklisp.org/2015/01/some-problems-when-adding-libraries-to.html