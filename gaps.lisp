(add-to-load-path "~/.stumpwm.d/modules/util/swm-gaps")

(load-module "swm-gaps")

(setf swm-gaps:*head-gaps-size* 0)
(setf swm-gaps:*inner-gaps-size* 0)
(setf swm-gaps:*outer-gaps-size* 8)

(swm-gaps:toggle-gaps)
