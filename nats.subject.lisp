
(in-package #:nats.subject)

(defun every-subject-char-p (str)
  (cl-ppcre:scan "^[^\\s\\r\\n]+$" str))

(deftype subject () 
  "SUBJECT must be a string containing at least one character,
and only visible characters."
  '(and string 
        (satisfies every-subject-char-p)))