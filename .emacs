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

