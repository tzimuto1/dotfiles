;; turn on automatic bracket insertion by pairs. New in emacs 24
(electric-pair-mode 1)

;; put some spaces when in linun-mode
(setq linum-format "%d ")

;; always turn on the linum-mode
(global-linum-mode t)

;; highlight a corresponding parenthesis when on a parethesis
(show-paren-mode 1)

;; indent upon clicking the return key
(global-set-key "\C-m" 'newline-and-indent)

;; prevent closing of emacs after accidentally typing C-z
(global-unset-key (kbd "C-z"))

;; don't make backup copies of files
(setq make-backup-files nil)

;; enable remembering of the recently closed files. Very important when I acciendentally close emacs [like I did a while ago
(require 'recentf)
(recentf-mode 1)

;; to keep ssh alive
;;(display-time-mode 1) 

;; change font color of minibuffer
;;(set-face-foreground 'minibuffer-prompt "white")

;; make indentation have width of four for C-mode
(setq c-basic-offset 4)
