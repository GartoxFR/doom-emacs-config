;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 17 :weight 'normal))
     ;; doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq catppuccin-flavor 'mocha)
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq my-clangd-query-drivers '(
                             "/usr/bin/gcc"
                             "/usr/bin/g++"
                             "/home/ewan/**/*gcc*"
                             "/home/ewan/**/*g++*"
                             ;; "/home/ewan/.platformio/packages/toolchain-atmelavr/bin/avr-g++"
                             ))

(setq lsp-clients-clangd-args (cons
                               (concat "--query-driver=" (string-join my-clangd-query-drivers ","))
                               '("-j=3"
                                 "--background-index"
                                 "--clang-tidy"
                                 "--completion-style=detailed"
                                 "--header-insertion=never"
                                 "--header-insertion-decorators=0")))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

(add-hook! 'rust-mode-hook (tree-sitter-hl-mode))
(add-hook! 'zig-mode-hook (tree-sitter-hl-mode))
(add-hook! 'c-mode-hook (tree-sitter-hl-mode))
(add-hook! 'c++-mode-hook (tree-sitter-hl-mode))


(emms-all)
(setq emms-seek-seconds 5
      emms-player-list '(emms-player-mpd)
      emms-info-functions '(emms-info-mpd))

(add-hook 'emms-browser-mode-hook 'emms-player-mpd-connect)

(map! :map global-map
      :leader
      :prefix "o"
      "p" #'mpc)

(map! :map global-map
      :leader
      "&" #'async-shell-command
      "!" #'shell-command)


(setq org-capture-templates
      '(("t" "Personal todo" entry
          (file+headline +org-capture-todo-file "Inbox")
          "* TODO %?\n%i\n%a" :prepend t)
        ("n" "Personal notes" entry
          (file+headline +org-capture-notes-file "Inbox")
          "* %u %?\n%i\n%a" :prepend t)
        ;; ("j" "Journal" entry
        ;;  (file+olp+datetree +org-capture-journal-file)
        ;;  "* %U %?\n%i\n%a" :prepend t)
        ("p" "Templates for projects")
        ("pt" "Project-local todo" entry
          (file+headline +org-capture-project-todo-file "Inbox")
          "* TODO %?\n%i\n%a" :prepend t)
        ("pn" "Project-local notes" entry
          (file+headline +org-capture-project-notes-file "Inbox")
          "* %U %?\n%i\n%a" :prepend t)
        ("pc" "Project-local changelog" entry
          (file+headline +org-capture-project-changelog-file "Unreleased")
          "* %U %?\n%i\n%a" :prepend t)
        ("o" "Centralized templates for projects")
        ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
        ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
        ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))

(add-hook 'mpc-mode-hook
 (lambda ()
   (keymap-local-set "C-k"        'windmove-up)
   (keymap-local-set "C-j"        'windmove-down)
   (keymap-local-set "C-h"        'windmove-left)
   (keymap-local-set "C-l"        'windmove-right)
   (evil-local-set-key 'normal (kbd  "C-<return>") 'mpc-play-at-point)
   (evil-local-set-key 'normal (kbd "<return>") 'mpc-select)
   (evil-local-set-key 'normal (kbd "t")      'mpc-toggle-play)
   (evil-local-set-key 'normal (kbd "s")          'mpc-toggle-shuffle)
   (evil-local-set-key 'normal (kbd ">")          '(mpc-seek-current +5))
   (evil-local-set-key 'normal (kbd "<")          '(mpc-seek-current -5))
   (evil-local-set-key 'normal (kbd "q")          'mpc-quit)
   (evil-local-set-key 'normal (kbd "c")          (lambda() (interactive) (mpc-playlist) (mpc-playlist-delete)))
   (evil-local-set-key 'normal (kbd "d")          (lambda() (interactive) (mpc-select) (mpc-playlist-delete)))
   (evil-local-set-key 'normal (kbd "n")          'mpc-next)
   (evil-local-set-key 'normal (kbd "p")          'mpc-playlist)
   (evil-local-set-key 'normal (kbd "P")          'mpc-prev)))

(setq shell-file-name "/usr/bin/bash")
(setq vterm-shell "/usr/bin/tmux")
(setenv "SHELL" shell-file-name)


(setq vterm-eval-cmds '(("find-file" find-file)
                        ("message" message)
                        ("vterm-clear-scrollback" vterm-clear-scrollback)
                        ("dired" dired)
                        ("ediff-files" ediff-files)))

(setq +mu4e-backend 'offlineimap)

(set-email-account! "Insa"
                    '((mu4e-sent-folder . "/insa/Sent")
                      (mu4e-drafts-folder . "/insa/Drafts")
                      (mu4e-trash-folder . "/insa/Trash")
                      (user-mail-address . "ewan.chorynski@insa-lyon.fr"))
                    t)
(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
	send-mail-function #'smtpmail-send-it
        mu4e-update-interval 300
	message-sendmail-f-is-evil t
	message-sendmail-extra-arguments '("--read-envelope-from")
	message-send-mail-function #'message-send-mail-with-sendmail))

(after! projectile (setq projectile-project-search-path '("~/dev")))

(after! company (map! :map company-active-map
      "RET" nil
      "<return>" nil
      "<tab>" nil
      "TAB" nil))

(after! company (map! :map company-active-map
      "C-y" #'company-complete-selection))
