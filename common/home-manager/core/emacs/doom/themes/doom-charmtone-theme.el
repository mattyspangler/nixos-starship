;;; doom-charmtone-theme.el --- Inspired by Charm Crush color palette -*- lexical-binding: t; -*-
(require 'doom-themes)

;;
(def-doom-theme charmtone
  "A dark theme inspired by the Charm Crush color palette."

  ;; name        gui   256   16
  ((bg         '("#201F26" nil   nil            )) ; Pepper
   (bg-alt     '("#2d2c35" nil   nil            )) ; BBQ  
   (bg-alt2    '("#3A3943" nil   nil            )) ; Charcoal
   (base0      '("#4D4C57" nil   nil            )) ; Iron
   (base1      '("#605F6B" nil   nil            )) ; Oyster
   (base2      '("#858392" nil   nil            )) ; Squid
   (base3      '("#BFBCC8" nil   nil            )) ; Smoke
   (base4      '("#DFDBDD" nil   nil            )) ; Ash
   (base5      '("#F1EFEF" nil   nil            )) ; Salt
   (base6      '("#FFFAF1" nil   nil            )) ; Butter
   (base7      '("#FFFFFF" nil   nil            )) ; White

   (fg         '("#DFDBDD" nil   nil            )) ; Ash
   (fg-alt     '("#BFBCC8" nil   nil            )) ; Smoke

   (grey       base2)
   (red        '("#EB4268" "#FF577D" "red"      )) ; Sriracha
   (orange     '("#FF985A" "#FF985A" "brightred")) ; Tang
   (green      '("#12C78F" "#00FFB2" "green"    )) ; Guac
   (teal       '("#68FFD6" "#68FFD6" "brightgreen")) ; Bok
   (yellow     '("#E8FE96" "#F5EF34" "yellow"   )) ; Zest
   (blue       '("#6B50FF" "#6B50FF" "brightblue")) ; Charple
   (dark-blue  '("#007AB8" "#007AB8" "blue"     )) ; Damson
   (magenta    '("#FF60FF" "#FF60FF" "magenta"  )) ; Dolly
   (violet     '("#C259FF" "#C259FF" "brightmagenta")) ; Violet
   (cyan       '("#00A4FF" "#00A4FF" "cyan"     )) ; Malibu
   (dark-cyan  '("#10B1AE" "#10B1AE" "cyan"     )) ; Zinc

   ;; face categories -- required for all themes
   (highlight      blue)
   (vertical-bar   (doom-darken base2 0.1))
   (selection      dark-blue)
   (builtin        magenta)
   (comments       (doom-lighten base2 0.2))
   (doc-comments   (doom-lighten comments 0.25))
   (constants      violet)
   (functions      magenta)
   (keywords       blue)
   (methods        cyan)
   (operators      blue)
   (type           yellow)
   (strings        teal)
   (variables      (doom-lighten fg 0.2))
   (numbers        violet)
   (region         (doom-lighten bg-alt 0.3))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (modeline-bg     bg-alt2)
   (modeline-bg-alt bg-alt)
   (modeline-fg     base4)
   (modeline-fg-alt base2)

   (-modeline-pad
    (when doom-charmtone-padded-modeline
      (if (integerp doom-charmtone-padded-modeline)
          doom-charmtone-padded-modeline
        4))))

  ;; --- extra faces ------------------------
  ((elscreen-tab-other-screen-face :background "#353a44" :foreground "#1e2022")

   ((line-number &override) :foreground base1)
   ((line-number-current-line &override) :foreground fg)

   (font-lock-comment-face
    :foreground comments
    :background (doom-darken bg 0.05))

   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)

   (mode-line
    :background modeline-bg
    :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color modeline-bg)))

   (mode-line-inactive
    :background modeline-bg-alt
    :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color modeline-bg-alt)))

   (mode-line-emphasis
    :foreground highlight)

   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color modeline-bg)))

   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color modeline-bg-alt)))

   ;; Doom specific faces
   (doom-modeline-bar :background blue)
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-modified :inherit 'mode-line-warning)
   (doom-modeline-buffer-major-mode :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-highlight :foreground blue :weight 'bold)

   ;; Ivy/Helm
   (ivy-current-match :background selection :distant-foreground bg :weight 'bold)
   (ivy-match-face-1 :foreground blue :weight 'bold)
   (ivy-match-face-2 :foreground magenta :weight 'bold)
   (ivy-match-face-3 :foreground green :weight 'bold)
   (ivy-match-face-4 :foreground yellow :weight 'bold)
   (ivy-confirm-face :foreground green)
   (ivy-done-face :foreground base4)
   (ivy-remote-face :foreground cyan)

   ;; Company
   (company-tooltip-common :foreground blue :weight 'bold)
   (company-tooltip-common-selection :foreground blue :weight 'bold)
   (company-tooltip-search :foreground yellow :weight 'bold)
   (company-tooltip-search-selection :foreground yellow :weight 'bold)
   (company-tooltip-annotation :foreground base3)
   (company-tooltip-annotation-selection :foreground base3)
   (company-tooltip-scrollbar-thumb :background bg-alt2)
   (company-tooltip-scrollbar-track :background bg)
   (company-tooltip-mouse :background selection :foreground fg)

   ;; Treemacs
   (treemacs-root-face :foreground blue :weight 'bold)
   (treemacs-directory-face :foreground cyan)
   (treemacs-file-face :foreground fg)
   (treemacs-git-modified-face :foreground orange)
   (treemacs-git-added-face :foreground green)
   (treemacs-git-deleted-face :foreground red)
   (treemacs-git-renamed-face :foreground magenta)
   (treemacs-git-ignored-face :foreground base2)

   ;; Org-mode
   (org-level-1 :foreground blue :weight 'bold :height 1.3)
   (org-level-2 :foreground magenta :weight 'bold :height 1.2)
   (org-level-3 :foreground teal :weight 'bold :height 1.1)
   (org-level-4 :foreground yellow :weight 'bold)
   (org-level-5 :foreground violet :weight 'bold)
   (org-level-6 :foreground green :weight 'bold)
   (org-level-7 :foreground orange :weight 'bold)
   (org-level-8 :foreground red :weight 'bold)
   (org-document-title :foreground blue :weight 'bold :height 1.4)
   (org-document-info :foreground cyan)
   (org-document-info-keyword :foreground base2)
   (org-link :foreground cyan :underline t)
   (org-code :foreground yellow :background (doom-darken bg 0.1))
   (org-verbatim :foreground violet :background (doom-darken bg 0.1))
   (org-quote :foreground base3 :background (doom-darken bg 0.05))
   (org-todo :foreground yellow :weight 'bold)
   (org-done :foreground green :weight 'bold)
   (org-headline-done :foreground base3 :weight 'normal)
   (org-block :background bg-alt)
   (org-block-begin-line :foreground base2 :background bg-alt)
   (org-block-end-line :foreground base2 :background bg-alt)
   (org-table :foreground cyan)
   (org-formula :foreground yellow)

   ;; Minibuffer
   (minibuffer-prompt :foreground blue :weight 'bold)

   ;; Window borders
   (window-divider :foreground vertical-bar)
   (window-divider-first-pixel :foreground vertical-bar)
   (window-divider-last-pixel :foreground vertical-bar)

   ;; Line numbers
   (linum :foreground base1 :background bg)
   (linum-relative :foreground base2 :background bg)

   ;; Fringe
   (fringe :foreground base1 :background bg)

   ;; Cursor
   (cursor :foreground bg :background blue)

   ;; Mouse
   (mouse :foreground fg :background base0)

   ;; Tooltips
   (tooltip :foreground fg :background bg-alt)

   ;; Search
   (isearch :background yellow :foreground bg :weight 'bold)
   (isearch-fail :background red :foreground fg)
   (lazy-highlight :background cyan :foreground bg :weight 'bold)

   ;; Parentheses
   (show-paren-match :background blue :foreground bg :weight 'bold)
   (show-paren-mismatch :background red :foreground fg :weight 'bold)

   ;; Rainbow delimiters
   (rainbow-delimiters-depth-1-face :foreground red)
   (rainbow-delimiters-depth-2-face :foreground orange)
   (rainbow-delimiters-depth-3-face :foreground green)
   (rainbow-delimiters-depth-4-face :foreground cyan)
   (rainbow-delimiters-depth-5-face :foreground blue)
   (rainbow-delimiters-depth-6-face :foreground magenta)
   (rainbow-delimiters-depth-7-face :foreground violet)
   (rainbow-delimiters-depth-8-face :foreground yellow)
   (rainbow-delimiters-depth-9-face :foreground teal)

   ;; Diff
   (diff-added :foreground green :background (doom-darken green 0.8))
   (diff-removed :foreground red :background (doom-darken red 0.8))
   (diff-changed :foreground yellow :background (doom-darken yellow 0.8))
   (diff-refine-added :foreground green :background (doom-darken green 0.7))
   (diff-refine-removed :foreground red :background (doom-darken red 0.7))
   (diff-refine-changed :foreground yellow :background (doom-darken yellow 0.7))

   ;; Git gutter
   (git-gutter:added :foreground green)
   (git-gutter:deleted :foreground red)
   (git-gutter:modified :foreground orange)

   ;; Diff-hl
   (diff-hl-change :background orange :foreground bg)
   (diff-hl-delete :background red :foreground fg)
   (diff-hl-insert :background green :foreground fg)

   ;; Dired
   (dired-directory :foreground cyan :weight 'bold)
   (dired-symlink :foreground magenta)
   (dired-ignored :foreground base2)
   (dired-mark :foreground yellow :weight 'bold)
   (dired-marked :foreground red :weight 'bold)
   (dired-flagged :foreground red :weight 'bold)

   ;; Error/Warning
   (error :foreground red :weight 'bold)
   (warning :foreground yellow :weight 'bold)
   (success :foreground green :weight 'bold)

   ;; Vterm
   (vterm-color-black :foreground bg)
   (vterm-color-red :foreground red)
   (vterm-color-green :foreground green)
   (vterm-color-yellow :foreground yellow)
   (vterm-color-blue :foreground blue)
   (vterm-color-magenta :foreground magenta)
   (vterm-color-cyan :foreground cyan)
   (vterm-color-white :foreground fg)

   ;; Compilation
   (compilation-info :foreground green)
   (compilation-warning :foreground yellow)
   (compilation-error :foreground red)

   ;; Flycheck
   (flycheck-error :foreground red :underline '(:style wave :color red))
   (flycheck-warning :foreground yellow :underline '(:style wave :color yellow))
   (flycheck-info :foreground cyan :underline '(:style wave :color cyan))

   ;; LSP
   (lsp-face-highlight-read :background (doom-darken blue 0.8))
   (lsp-face-highlight-text :background (doom-darken yellow 0.8))
   (lsp-face-highlight-write :background (doom-darken orange 0.8))

   ;; Which-key
   (which-key-key :foreground blue :weight 'bold)
   (which-key-description :foreground fg)
   (which-key-group-description :foreground magenta)
   (which-key-separator :foreground base2)
   (which-key-highlight-face :foreground yellow)

   ;; Dashboard
   (doom-dashboard-banner :foreground blue)
   (doom-dashboard-footer :foreground base2)
   (doom-dashboard-header :foreground magenta)
   (doom-dashboard-loaded :foreground green)
   (doom-dashboard-menu-desc :foreground base3)
   (doom-dashboard-menu-title :foreground cyan :weight 'bold)

   ;; Neotree
   (neo-banner :foreground blue :weight 'bold)
   (neo-header :foreground magenta :weight 'bold)
   (neo-root-dir-face :foreground blue :weight 'bold)
   (neo-file-link-face :foreground fg)
   (neo-dir-link-face :foreground cyan)
   (neo-expand-btn-face :foreground base2)

   ;; Tab-bar
   (tab-bar :background bg :foreground base2)
   (tab-bar-tab :background bg-alt :foreground fg)
   (tab-bar-tab-inactive :background bg :foreground base2)
   (tab-bar-tab-foreground-inactive :foreground base2))

  ;; --- extra variables --------------------
  (;; Fixes
   (line-number-spacing nil)
   (tab-width 4)))

;;; doom-charmtone-theme.el ends here