
(ql:quickload :cl-nats)

(setf nats.vars::*debug* t)

(defvar con (nats::make-connection :name "test"))

;(when (y-or-n-p "publish?")
;  (cl-nats::publish con "foo" "test"))