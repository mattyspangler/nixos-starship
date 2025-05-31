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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'spacemacs-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Notetaking/")

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

;; Get my sops-nix secrets set up
(defvar nano-gpt-api-key nil
  "Nano-GPT API key loaded from a sops-nix managed file")

(defun load-secret-key ()
  "Load secret key from file into variable"
  (with-temp-buffer
    (insert-file-contents "~/.config/sops-nix/secrets/nano-gpt_key")
    (setq nano-gpt-api-key (string-trim (buffer-string)))
    (kill-buffer)))

(if (file-exists-p "~/.config/sops-nix/secrets/nano-gpt_key")
    (load-secret-key)
  (add-hook 'after-init-hook #'load-secret-key))

;; Doom Emacs Banner
(setq fancy-splash-image (concat doom-private-dir "splash.png"))

;; Scrolling
(setq mouse-wheel-scroll-amount '(2)) ;; or (0.07)
(setq mouse-wheel-progressive-speed nil)
(setq scroll-margin 1)
(setq scroll-step 2)
(setq scroll-conservatively 10000)
(setq scroll-preserve-screen-position 1)

;; Treemacs settings
(setq treemacs-indent-guide-style 'line)   ; Use 'line, 'dot, or 'block
(setq treemacs-indent-guide-delay 0.1)     ; Show guides faster after expanding
(setq treemacs-indent-guide-color "#555555") ; Subtle gray color for guides
(setq treemacs-indent-guide-add-to-all-levels t) ; Show even on first level
(add-hook 'window-setup-hook #'+treemacs/toggle 'append)

;; Org settings
(setq org-directory (list "~/Documents/Notetaking"))

; Agenda
(setq org-agenda-files (directory-files-recursively "~/Documents/Notetaking/" "\\.org$"))

; Logbook for reoccuring tasks marked done:
; https://www.reddit.com/r/orgmode/comments/e62eka/orgagenda_recording_recurring_tasks/
(setq org-log-done 'time
      org-log-into-drawer t)

; Habits
(add-to-list 'org-modules 'org-habit t)

; Get rid of overlay that prevents me from reading my habit tasks
(setq org-habit-graph-column 70)

; each state with ! is recorded as state change
; in this case I'm logging TODO and DONE states
(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n)" "SOMD(s)" "WAFO(w)" "|" "DONE(d!)" "CANC(c!)")))
; I prefer to log TODO creation also
(setq org-treat-insert-todo-heading-as-state-change t)

;; Yasnippet
(setq yas-snippet-dirs
      '("~/Documents/Notetaking/snippets" ;; personal snippets
        ))
(yas-global-mode 1)

;; Machine Learning / Deep Learning / Large Language Models:

; This package tends to be used by other AI-related packages
(use-package! gptel
  :config
  (setq gptel-model 'TEE/deepseek-r1-70b
        gptel-backend
        (gptel-make-openai "Nano-GPT"
          :host "nano-gpt.com"
          :endpoint "/api/v1/chat/completions"
          :stream t
          :key nano-gpt-api-key
          :models '(deepseek-r1-nano
                    qwen/qwen3-14b
                    Qwen3-32B
                    deekseek-chat
                    claude-sonnet-4-20250514
                    claude-sonnet-4-thinking
                    claude-opus-4-20250514
                    claude-opus-4-thinking
                    TEE/deepseek-r1-70b))))

; TODO: MCP

; Alternative Chat
(use-package ellama
  :bind ("C-c e" . ellama)
  ;; send last message in chat buffer with C-c C-c
  :hook (org-ctrl-c-ctrl-c-final . ellama-chat-send-last-message)
  :init (setopt ellama-auto-scroll t)
  :ensure t
  :config
  (setq ellama-sessions-directory "~/.config/emacs/.local/cache/ellama-sessions")
  (require 'llm-openai)
  (require 'llm-ollama)
  (setopt ellama-providers
        '(("Nano-GPT" . (make-llm-openai-compatible
                          :key nano-gpt-api-key
                          :url "https://nano-gpt.com/api/v1/"
                          :chat-model "TEE/deepseek-r1-70b"))
          ("OpenAI-Compatible" . (make-llm-openai-compatible
                                   :key nano-gpt-api-key
                                   :url "https://nano-gpt.com/api/v1/"))))
  (setopt ellama-coding-provider
        (make-llm-ollama
         :chat-model "qwen2.5-coder:1.5b-base"
         :embedding-model "nomic-embed-text"
         :default-chat-non-standard-params '(("num_ctx" . 32768)))))
;
; LLM Autocompletion
(use-package! minuet
  :config
  (setq minuet-provider 'openai-fim-compatible)
  (setq minuet-n-completions 1)
  (setq minuet-context-window 512)
  (plist-put minuet-openai-fim-compatible-options :end-point "http://localhost:11434/v1/completions")
  (plist-put minuet-openai-fim-compatible-options :name "Ollama")
  (plist-put minuet-openai-fim-compatible-options :api-key "TERM")
  (plist-put minuet-openai-fim-compatible-options :model "qwen2.5-coder:1.5b-base")

  ;Prioritize throughput for faster completion
  (minuet-set-optional-options minuet-openai-fim-compatible-options :provider '(:sort "throughput"))
  (minuet-set-optional-options minuet-openai-fim-compatible-options :max_tokens 56)
  (minuet-set-optional-options minuet-openai-fim-compatible-options :top_p 0.9))

;; org-ai configuration for #+begin_ai blocks
(use-package! org-ai
  :commands (org-ai-mode
             org-ai-global-mode)
  :init
  (add-hook 'org-mode-hook #'org-ai-mode)
  (org-ai-global-mode)
  :config
  (setq org-ai-openai-compatible-api-url "https://nano-gpt.com/api/v1/")
  (setq org-ai-openai-compatible-api-key nano-gpt-api-key)
  (setq org-ai-default-chat-model "TEE/deepseek-r1-70b")
  (org-ai-install-yasnippets))

; Cursor-style agentic coding (bleeding edge and unstable)
(use-package emigo
  :files (:defaults "*.py" "*.el")
  :config
  (emigo-enable)
  :custom
  (emigo-python-command "~/Coding/Python/emigo_venv/bin/python")
  (emigo-model "TEE/deepseek-r1-70b")
  (emigo-base-url "https://nano-gpt.com/api/v1")
  (emigo-api-key (getenv nano-gpt-api-key)))

(use-package aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
  (setenv "OPENAI_API_KEY" nano-gpt-api-key)
  :custom
  (aidermacs-use-architect-mode t)
  (setq aidermacs-backend 'vterm)
  (setq aidermacs-default-mode "TEE/deepseek-r1-70b")
  (setq aidermacs-architect-mode "TEE/deepseek-r1-70b")
  (setq aidermacs-editor-model "Qwen/Qwen2.5-Coder-32B-Instruct")
  (setq aidermacs-show-diff-after-change t)
  (setq aidermacs-global-read-only-files '("~/.aider/AI_RULES.md"))
  (setq aidermacs-project-read-only-files '("CONVENTIONS.md" "README.md")))
