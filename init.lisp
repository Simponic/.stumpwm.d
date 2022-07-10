(in-package :stumpwm)

;; Utils and helpers
(load "~/.stumpwm.d/utils.lisp")

;; Local configuration
(load "~/.stumpwm.d/local.lisp")

;; Swank
(load "~/.stumpwm.d/swank.lisp")

;; Keybindings and whatnot
(load "~/.stumpwm.d/keyboard.lisp")

;; Groups
(load "~/.stumpwm.d/groups.lisp")

;; Follow focus on mouse hover
(setq *mouse-focus-policy* :sloppy)

;; The actual rice
(load "~/.stumpwm.d/theme.lisp")
(load "~/.stumpwm.d/gaps.lisp")
(load "~/.stumpwm.d/modeline.lisp")

;; Set Background
(run-shell-command "~/scripts/setWallpaper.sh")
;; Use emacs keybindings everywhere
(run-shell-command "emacs-keys-everywhere")
