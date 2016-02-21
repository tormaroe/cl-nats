
(defvar *client* (nats:make-connection :name "*client*"))
(defvar *server* (nats:make-connection :name "*server*"))

(nats:wait-for-connection *client*)
(nats:wait-for-connection *server*)

(setf nats:*debug* t)

(nats:subscribe *server* "echo"
  (lambda (msg &optional reply-to)
    (format t "SERVER: got '~A'~%" msg)
    (when reply-to
      (nats:publish *server* reply-to 
                    (format nil "ECHO ~A" msg)))))


;; Request a reply
(nats:request *client* "echo" "I'd like a reply"
  (lambda (msg &optional reply-to)
    (format t "CLIENT: got '~A' '~A'~%" msg reply-to)))

;; Fire and forget..
(nats:publish *client* "echo" "I don't really care")