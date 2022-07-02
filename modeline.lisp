
(defun make-bar (label percentage-function)
  (let
      ((percentage (funcall percentage-function)))
    (concat label ": \[" (bar percentage 5 #\X #\=) "\]" (format nil "(~a\%)" percentage))))

(defun get-volume ()
  ;; Return the volume as a percentage
  (parse-integer (run-shell-command "pamixer --get-volume" t)))

(defun get-battery ()
  ;; Return the current battery level as a percentage
  (parse-integer (run-shell-command "acpi | awk -F ',' '{print $2}' | grep -Po '\\d+'" t)))

(defun get-wifi ()
  ;; Return wifi signal strength as a percentage
  (parse-integer (run-shell-command "printf $(iwconfig 2> /dev/null | grep -Pio '(?<=Link Quality=)\d+')" t)))

(defun get-ip ()
  ;; Return the current ip of the default network interface
  (run-shell-command "printf $(ifconfig $(route | grep '^default' | grep -o '[^ ]*$') | grep -Po '\\d+\\.\\d+\\.\\d+\\.\\d+' | head -n1)" t))

(defun insert-seperators (l &optional (seperator " | ") (seperated-list (list seperator)))
  (if (cdr l)
      (insert-seperators (cdr l) seperator (nconc (list seperator (car l)) seperated-list))
      (reverse seperated-list)))

(setf *status-seperator* " ^3|^] ")
(setf *screen-mode-line-format*
      (insert-seperators
        (list
          "[^B%n^b]"
          "%g"
          "%W"
          "^>"
          "%d"
          '(:eval (make-bar "VOL" #'get-volume))
          '(:eval (make-bar "WIFI" #'get-wifi))
          '(:eval (get-ip))
          (if *laptop* '(:eval (make-bar "BAT" #'get-battery))))
        *status-seperator*))

(setf *window-format* "%n%s%c")
(setf *time-modeline-string* "%a %b %e %k:%M:%S")
(setf *mode-line-timeout* 1)



;; Show on each screen
(mapcar
 (lambda (x)
   (stumpwm:enable-mode-line (stumpwm:current-screen) x t))
 (stumpwm:screen-heads (stumpwm:current-screen)))
