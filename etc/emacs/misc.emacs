;;
;; misc.emacs for ctafconf in /home/ctaf/IBC/batail_s-ibc2
;;
;; Made by GESTES Cedric
;; Login   <ctaf@epita.fr>
;;
;; Started on  Mon Jan 16 01:12:29 2006 GESTES Cedric
;; Last update Fri Feb 10 20:00:40 2006 GESTES Cedric
;;
;;screensaver
(message "ctafconf loading: MISC.EMACS")

;;screensaver
(when (>= emacs-major-version 21)
  (require 'zone)
  (setq zone-idle 300)
  (zone-when-idle 300))