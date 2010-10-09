;;
;; startup.emacs for ctafconf in /home/ctaf/IBC/batail_s-ibc2
;;
;; Made by GESTES Cedric
;; Login   <ctaf42@gmail.com>
;;
;; Started on  Mon Jan 16 01:00:22 2006 GESTES Cedric
;; Last update Sat Mar 22 12:39:28 2008 GESTES Cedric
;;
(message ".")
(message "ctafconf loading: STARTUP.EMACS")

;; Change startup message...
(defcustom hinitial-scratch-message (purecopy "\
;; CTAFCONF Emacs (http://github.com/ctaf42/ctafconf/)

;;===GLOBAL KEYBINDING===
;; F1	    SHOW THIS HELP	         S-F1	       man
;; F2	    find in file                 S-F2	       find in each file
;; F3	    query-replace                S-F3	       replace-string
;; C-F3	    list all occurence
;; F4	    comment or uncomment region  S-F4
;; F5	    toggle speedbar	         S-F5	       terminal
;; F6	    toggle source/header file    S-F6
;; F7	          	                 S-F7
;; F8	    Compile		         S-F8	       Debug
;; F9	    next error	                 S-F9	       previous error
;; F10	          		         S-F10
;; F11	    show ecb (code browser)      S-F11	       hide ecb (code browser)
;; A-PageUp scroll-other-window          A-PageDown    scroll-other-window-down

;;===FILE/BUFFER OPERATION===
;; c-x c-f          open one file
;;   M-UP, M-DOWN   move into the directory history
;; info: to get the standard open file [C-x C-f] then [C-f]
;;
;; M-left           previous buffer
;; M-right          next buffer
;; C-TAB            change window

;;===MINIBUFFER===
;; when you do: M-x, C-x b, etc..
;;  C-n  next element in the history
;;  C-p  previous element in the history

;;===EDITION===
;; M-x dos2unix           convert a Dos format to unix format
;; C-return		  Box-mode selection (square selection)
;; M-x e (then repeat e)  Recall last kbd macro, 'C-x (' record, 'C-x )' stop recording
;; M-g M-g		  Goto-line
;; C-_ , C-z		  undo
;; C-c r		  revert buffer
;; M-y			  choose from previous copied string (browse kill-ring)

;;===PROGRAMMATION===
;; m-x global-linum-mode  toggle line number on the left
;; [TAB]		  inline completion
;; c-x 4 a		  add one entry to the ChangeLog
;;
;; DoxyEmacs
;;   C-c d ?    will look up documentation for the symbol under the point.
;;   C-c d r    will rescan your Doxygen tags file.
;;   C-c d f    will insert a Doxygen comment for the next function.
;;   C-c d i    will insert a Doxygen comment for the current file.
;;   C-c d ;    will insert a Doxygen comment for a member variable on the current line (like M-;).
;;   C-c d m    will insert a blank multi-line Doxygen comment.
;;   C-c d s    will insert a blank single-line Doxygen comment.
;;   C-c d @    will insert grouping comments around the current region.

;;===DEBUG(S-F8)/COMPILATION(F8)===
;; when using debug mode:
;; c-up / c-down  cycle through history
;; c-x SPC        set a break point in a source file
;; c-c c-c        send a INT signal (a simple c-c in fact)
;; c-x c-a c-n    NEXT
;; c-x c-a c-s    STEP
;; c-x c-a c-u    UNTIL
;; c-x c-a c-j    JUMP
;; c-x c-a c-l    display the current line in the source code
;; c-x c-a c-p    print the value of the variable under the cursor

;;===TERMINAL(S-F5)===
;; c-c c-j        line mode
;; c-c c-k        char mode
;; c-c c-c        control-c in a term (interrupt)

;;===ELISP PROGRAMMING/DEBUGGING===
;; - c-x c-e :evaluate elisp expression
;; emacs --debug-init
;; emacs -Q (load an empty emacs without using config file)
;; - learn one key:
;;   M-x global-set-key
;;   C-x ESC ESC (affiche la commande precedente nikel chrome)
;; IN THE ELISP DEBUGGER:
;; - q : quit emacs backtrace (when debugging lisp)
;; - e : evaluate an expression
;; - d : step through code one step at a time
;; - c : continue the computation
;;
") "Initial message displayed in *scratch* buffer at startup.
If this is nil, no message will be displayed."
  :type 'string)

(defun ctafconf-help ()
  (with-current-buffer (get-buffer "*scratch*")
    (erase-buffer)
    (when hinitial-scratch-message
      (insert hinitial-scratch-message))
    (set-buffer-modified-p nil)))

(ctafconf-help)
