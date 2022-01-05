(ql:quickload :parse-float)

(defun make-bar (percentage-function)
  (let
      ((percentage (funcall percentage-function)))
    (concat "\[" (bar percentage 5 #\X #\=) "\]" (format nil "(~a\%)" percentage))))

(defun get-volume ()
  (parse-integer (run-shell-command "pamixer --get-volume" t)))

(defun get-battery ()
  (parse-integer (run-shell-command "printf $(acpi | grep -o '[[:digit:]]*\%')" t)))

(setf *window-format* "%m%n%s%c")
(setf *time-modeline-string* "%a %b %e %k:%M:%S")
(setf *mode-line-timeout* 1)
(setf *screen-mode-line-format*
      (list
        "[^B%n^b]  //  %g  \\\\  %W  // ^> VOL: "
        '(:eval (make-bar #'get-volume))
        " BAT: "
        '(:eval (make-bar #'get-battery))
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
