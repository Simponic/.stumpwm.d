(ql:quickload :parse-float)

(defun make-bar (label percentage-function)
  (let
      ((percentage (funcall percentage-function)))
    (concat label ": \[" (bar percentage 5 #\X #\=) "\]" (format nil "(~a\%)" percentage))))

(defun get-volume ()
  ;; Return the volume as a percentage
  (parse-integer (run-shell-command "pamixer --get-volume" t)))

(defun get-battery ()
  ;; Return the current battery level as a percentage
  (parse-integer (run-shell-command "printf $(acpi | grep -o '[[:digit:]]*\%')" t)))

(defun get-wifi ()
  ;; Return wifi signal strength as a percentage
  (parse-integer (run-shell-command "awk 'NR==3 { printf("%i"), $3/70*100 } /proc/net/wireless'")))

(setf *window-format* "%m%n%s%c")
(setf *time-modeline-string* "%a %b %e %k:%M:%S")
(setf *mode-line-timeout* 1)
(setf *screen-mode-line-format*
      (list
        "[^B%n^b]  //  %g  \\\\  %W  // ^> "
        '(:eval (make-bar "VOL" #'get-volume))
        (cond
          (*laptop* '(:eval "BAT" (make-bar #'get-battery)))
          (t ""))
        '(:eval (make-bar "WIFI" #'get-wifi))
        "  \\\\  %d"
       ))

(setf *bar-med-color* "^B^1") ;; Red
(setf *bar-hi-color* "^B^2") ;; Green
(setf *bar-crit-color* "^B^3") ;; Yellow

;; Show on each screen
(mapcar
 (lambda (x)
   (stumpwm:enable-mode-line (stumpwm:current-screen) x t))
 (stumpwm:screen-heads (stumpwm:current-screen)))
