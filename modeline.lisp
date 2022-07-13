(defun make-bar (label percentage-function &optional (format-string "(~a\%)"))
  (let
      ((percentage (funcall percentage-function)))
    (concat label ": \[" (bar percentage 5 #\X #\=) "\]" (format nil format-string percentage))))

(defun get-volume ()
  ;; Return the volume as a percentage
  (parse-integer (run-shell-command "pamixer --get-volume" t)))

(defun get-battery ()
  ;; Return the current battery level as a percentage
  (parse-integer (run-shell-command "acpi | awk -F ',' '{print $2}' | grep -Po '\\d+'" t)))

(defun get-ip ()
  ;; Return the current ip of the default network interface
  (run-shell-command "printf $(ifconfig $(route | grep '^default' | grep -o '[^ ]*$') | grep -Po '\\d+\\.\\d+\\.\\d+\\.\\d+' | head -n1)" t))

(defun get-cpu-temp ()
  ;; Return current temperature of the first cpu package (core)
  (parse-integer (run-shell-command "sensors -A | grep 'Package' | awk '{print $4+0}'" t)))
        
(setf *status-seperator* " ^3|^] ")
(setf *mode-line* '(
                    "[^B%n^b]"
                    "%g"
                    "%W"
                    "^>"
                    "%d"
                    (:eval (make-bar "VOL" #'get-volume))
                    (:eval (make-bar "TEMP" #'get-cpu-temp "(~a°C)"))
                    (:eval (get-ip))))
(if (is-laptop)
    (push '(:eval (make-bar "BAT" #'get-battery)) (cdr (last *mode-line*))))
(setf *screen-mode-line-format* (insert-seperators *mode-line* *status-seperator*))

(setf *window-format* "%n%s%c")
(setf *time-modeline-string* "%a %b %e %k:%M:%S")
(setf *mode-line-timeout* 1)

;; Show on each screen
(mapcar
 (lambda (x)
   (stumpwm:enable-mode-line (stumpwm:current-screen) x t))
 (stumpwm:screen-heads (stumpwm:current-screen)))
