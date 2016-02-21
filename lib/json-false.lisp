
;;; Borrowed this code from Stack Overflow anser by user jlhad.
;;; http://stackoverflow.com/questions/27679494/how-to-output-false-while-using-cl-json/27685316#27685316
;;;

(in-package #:json-false)

(defclass json-false ()
  ())

(defmethod json:encode-json ((object json-false) &optional stream)
  (princ "false" stream)
  nil)

(defvar *json-false* (make-instance 'json-false))

(defun json-bool (val)
  (if val t *json-false*))

(defun json-bool-handler (token)
  (or (string= token "true")
      (and (string= token "false") *json-false*)))

(defmacro preserving-json-boolean (opts &body body)
  (declare (ignore opts))
  `(let ((json:*boolean-handler* #'json-bool-handler))
     ,@body))