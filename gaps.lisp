(add-to-load-path "~/.stumpwm.d/modules/util/swm-gaps")

(load-module "swm-gaps")

(setf swm-gaps:*head-gaps-size* 0
      swm-gaps:*inner-gaps-size* 5
      swm-gaps:*outer-gaps-size* 5)

(swm-gaps:toggle-gaps)
