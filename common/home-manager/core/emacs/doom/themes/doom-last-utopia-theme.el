;;; doom-last-utopia-theme.el --- A dark theme inspired by the Charmtone/Crush color palette -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Added: November 2025
;; Author: Nebula <nebula@system>
;; Maintainer: Matty Spangler <https://github.com/mattyspangler>
;;

(require 'doom-themes)

;;
;;; Variables

(defgroup doom-last-utopia-theme nil
  "Options for the `doom-last-utopia' theme."
  :group 'doom-themes
  :prefix 'doom-last-utopia-)

(defcustom doom-last-utopia-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-last-utopia-theme
  :type 'boolean)

(defcustom doom-last-utopia-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-last-utopia-theme
  :type 'boolean)

(defcustom doom-last-utopia-comment-bg doom-last-utopia-brighter-comments
  "If non-nil, comments will have a subtle, darker background."
  :group 'doom-last-utopia-theme
  :type 'boolean)

(defcustom doom-last-utopia-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-last-utopia-theme
  :type '(choice integer boolean))

;;
;;; Theme definition

(def-doom-theme doom-last-utopia
  "A dark theme inspired by the Charmtone/Crush color palette"

  ;; Color palette
  ;; name        default   256       16
  ((bg         '("#201F26" "#201F26" "black"          )) ; Pepper
    (fg         '("#DFDBDD" "#DFDBDD" "brightwhite"    )) ; Ash
    (bg-alt     '("#2d2c35" "#2d2c35" "brightblack"    )) ; BBQ  
    (fg-alt     '("#BFBCC8" "#BFBCC8" "brightwhite"    )) ; Smoke

    (base0      '("#201F26" "#201F26" "black"          )) ; Pepper
    (base1      '("#2d2c35" "#2d2c35" "brightblack"    )) ; BBQ
    (base2      '("#3A3943" "#3A3943" "brightblack"    )) ; Charcoal
    (base3      '("#4D4C57" "#4D4C57" "brightblack"    )) ; Iron
    (base4      '("#605F6B" "#605F6B" "brightblack"    )) ; Oyster
    (base5      '("#858392" "#858392" "brightblack"    )) ; Squid
    (base6      '("#BFBCC8" "#BFBCC8" "brightwhite"    )) ; Smoke
    (base7      '("#DFDBDD" "#DFDBDD" "brightwhite"    )) ; Ash
    (base8      '("#F1EFEF" "#F1EFEF" "white"          )) ; Salt

    (grey       '("#858392" "#858392" "brightblack"    )) ; Squid
    (red        '("#EB4268" "#EB4268" "red"            )) ; Sriracha
    (orange     '("#FF985A" "#FF985A" "brightred"      )) ; Tang
    (green      '("#12C78F" "#12C78F" "green"          )) ; Guac
    (teal       '("#10B1AE" "#10B1AE" "brightgreen"    )) ; Zinc
    (yellow     '("#E8FE96" "#E8FE96" "yellow"         )) ; Zest
    (blue       '("#00A4FF" "#00A4FF" "blue"           )) ; Malibu
    (dark-blue  '("#007AB8" "#007AB8" "blue"           )) ; Damson
    (magenta    '("#FF60FF" "#FF60FF" "magenta"        )) ; Dolly
    (violet     '("#C259FF" "#C259FF" "brightmagenta"  )) ; Violet
    (cyan       '("#00D9FF" "#00D9FF" "cyan"           )) ; Ripple
    (dark-cyan  '("#0ADCD9" "#0ADCD9" "cyan"           )) ; Turtle

    ;; Last Utopia specific colors
    (charple    '("#6B50FF" "#6B50FF" "brightmagenta"  )) ; Primary
    (dolly      '("#FF60FF" "#FF60FF" "magenta"        )) ; Secondary  
    (ripple     '("#00D9FF" "#00D9FF" "cyan"           )) ; Tertiary
    (blush      '("#FF388B" "#FF388B" "brightmagenta"  )) ; Quaternary
    (zest       '("#E8FE96" "#E8FE96" "yellow"         )) ; Accent

    ;; Additional colors for variety
    (hazy       '("#8B75FF" "#8B75FF" "brightmagenta"  )) ; Light purple-blue
    (sardine    '("#4FBEFE" "#4FBEFE" "brightcyan"     )) ; Light blue
    (julep      '("#00FFB2" "#00FFB2" "brightgreen"    )) ; Bright green
    (yam        '("#FFB587" "#FFB587" "brightred"      )) ; Light orange
    (coral      '("#FF577D" "#FF577D" "red"            )) ; Coral

    ;; Face categories -- required for all themes
    (highlight      blue)
    (vertical-bar   (doom-darken base2 0.1))
    (selection      dark-blue)
    (builtin        magenta)
    (comments       (if doom-last-utopia-brighter-comments base5 base4))
    (doc-comments   (doom-lighten (if doom-last-utopia-brighter-comments base5 base4) 0.25))
    (constants      violet)
    (functions      magenta)
    (keywords       blue)
    (methods        cyan)
    (operators      blue)
    (type           yellow)
    (strings        yam)
    (variables      base7)
    (numbers        orange)
    (region         `(,(doom-lighten base2 0.15)))
    (error          red)
    (warning        yellow)
    (success        green)
    (vc-modified    orange)
    (vc-added       green)
    (vc-deleted     red)

    ;; Extra faces used in Last Utopia
    (modeline-bg     (if doom-last-utopia-brighter-modeline
                       (doom-lighten base2 0.15)
                     base2))
    (modeline-bg-alt (if doom-last-utopia-brighter-modeline
                        (doom-lighten base2 0.1)
                      base1))
    (modeline-fg     base6)
    (modeline-fg-alt comments)

    (-modeline-pad
     (when doom-last-utopia-padded-modeline
       (if (integerp doom-last-utopia-padded-modeline) doom-last-utopia-padded-modeline 4))))

   ;;;; Base theme face overrides
  (((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg :background base2)
   ((paren-face &override) :foreground base4)
   ((paren-face-match &override) :foreground charple :background base3 :weight 'bold)
   ((paren-face-mismatch &override) :foreground red :background base3 :weight 'bold)

   ;; Mode-line faces
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-alt :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (mode-line-emphasis
    :foreground (if doom-last-utopia-brighter-modeline base8 highlight))

   ;; Header-line
   (header-line :background base2 :foreground fg)

   ;; Syntax highlighting
   ((font-lock-comment-face &override)
    :foreground comments
    :background (if doom-last-utopia-comment-bg (doom-darken bg 0.05)))
   ((font-lock-doc-face &override)
    :foreground doc-comments)
   (font-lock-string-face :foreground strings)
   (font-lock-constant-face :foreground constants)
   (font-lock-function-name-face :foreground functions)
   (font-lock-keyword-face :foreground keywords :weight 'bold)
   (font-lock-type-face :foreground type)
   (font-lock-variable-name-face :foreground variables)
   (font-lock-builtin-face :foreground builtin)
   (font-lock-number-face :foreground numbers)

    ;; Company completions
    (company-tooltip-selection :background selection)
    (company-tooltip-common :foreground charple)

    ;; Search
    (isearch :foreground base0 :background yellow)
    (lazy-highlight :foreground yellow :background base3)

    ;; Ivy/Vertico/Selectrum
    (ivy-current-match :background selection)
    (ivy-match-required-face :foreground red)
    (ivy-confirm-face :foreground green)
    (ivy-remote :foreground cyan)

    ;; Which-key
    (which-key-key :foreground charple)
    (which-key-group-separator :foreground base4)
    (which-key-separator :foreground base4)

    ;; Doom modeline
    (doom-modeline-bar :background (if doom-last-utopia-brighter-modeline modeline-bg highlight))
    (doom-modeline-buffer-path :foreground green :weight 'bold)
    (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
    (doom-modeline-buffer-modified :foreground orange)
    (doom-modeline-buffer-major-mode :foreground magenta :weight 'bold)
    (doom-modeline-highlight :foreground magenta :weight 'bold)

    ;; Org-mode
    (org-level-1 :foreground charple :weight 'bold :height 1.2)
    (org-level-2 :foreground dolly :weight 'bold :height 1.1)
    (org-level-3 :foreground ripple :weight 'bold)
    (org-level-4 :foreground blush :weight 'bold)
    (org-level-5 :foreground zest :weight 'bold)
    (org-level-6 :foreground violet :weight 'bold)
    (org-level-7 :foreground hazy :weight 'bold)
    (org-level-8 :foreground sardine :weight 'bold)
    (org-headline-done :foreground base5)
    (org-todo :foreground yellow :weight 'bold)
    (org-done :foreground green :weight 'bold)
    (org-date :foreground cyan)
    (org-link :foreground charple :underline t)
    (org-code :background base3 :foreground sardine)
    (org-block :background base2 :foreground fg)
    (org-block-begin-line :background base2 :foreground base5)
    (org-block-end-line :background base2 :foreground base5)

    ;; Markdown
    (markdown-header-face-1 :foreground charple :weight 'bold :height 1.2)
    (markdown-header-face-2 :foreground dolly :weight 'bold :height 1.1)
    (markdown-header-face-3 :foreground ripple :weight 'bold)
    (markdown-header-face-4 :foreground blush :weight 'bold)
    (markdown-header-face-5 :foreground zest :weight 'bold)
    (markdown-header-face-6 :foreground violet :weight 'bold)
    (markdown-link-face :foreground charple :underline t)
    (markdown-code-face :background base3 :foreground sardine)

    ;; Git/Version control
    (git-commit-comment-action :foreground magenta)
    (git-commit-comment-branch :foreground blue)
    (git-commit-comment-file :foreground cyan)
    (git-commit-comment-heading :foreground yellow :weight 'bold)
    (git-commit-summary :foreground fg)
    (git-commit-nonempty-second-line :foreground fg)

    ;; Diff
    (diff-added :foreground (doom-lighten green 0.2) :background (doom-darken green 0.7))
    (diff-removed :foreground (doom-lighten red 0.2) :background (doom-darken red 0.7))
    (diff-changed :foreground (doom-lighten yellow 0.2) :background (doom-darken yellow 0.7))
    (diff-refine-added :foreground green :background (doom-darken green 0.6) :weight 'bold)
    (diff-refine-removed :foreground red :background (doom-darken red 0.6) :weight 'bold)
    (diff-refine-changed :foreground yellow :background (doom-darken yellow 0.6) :weight 'bold)

    ;; Magit
    (magit-section-heading :foreground charple :weight 'bold)
    (magit-section-highlight :background base2)
    (magit-hash :foreground cyan)
    (magit-branch-local :foreground green)
    (magit-branch-remote :foreground orange)
    (magit-diff-added :foreground green :background (doom-darken green 0.8))
    (magit-diff-removed :foreground red :background (doom-darken red 0.8))
    (magit-diff-context :foreground base5)
    (magit-diff-hunk-heading :background base3 :foreground fg :weight 'bold)

    ;; Treemacs
    (treemacs-root-face :foreground charple :weight 'bold)
    (treemacs-directory-face :foreground blue)
    (treemacs-file-face :foreground fg)
    (treemacs-git-modified-face :foreground orange)
    (treemacs-git-added-face :foreground green)
    (treemacs-git-conflict-face :foreground red)
    (treemacs-git-untracked-face :foreground yellow)

    ;; Neotree
    (neo-dir-link-face :foreground blue :weight 'bold)
    (neo-file-link-face :foreground fg)
    (neo-root-dir-face :foreground charple :weight 'bold)
    (neo-expand-btn-face :foreground base5)

    ;; Minibuffer/Completions
    (completions-annotations :foreground base5)
    (completions-common-part :foreground charple)
    (completions-first-difference :foreground orange :weight 'bold)

    ;; Error/warning/success faces
    (error :foreground red :weight 'bold)
    (warning :foreground yellow :weight 'bold)
    (success :foreground green :weight 'bold)

    ;; Tooltip
    (tooltip :background base3 :foreground fg)

    ;; Show-paren
    (show-paren-match :foreground charple :background base3 :weight 'bold)
    (show-paren-mismatch :foreground red :background base3 :weight 'bold)

    ;; Rainbow delimiters
    (rainbow-delimiters-depth-1-face :foreground charple)
    (rainbow-delimiters-depth-2-face :foreground dolly)
    (rainbow-delimiters-depth-3-face :foreground ripple)
    (rainbow-delimiters-depth-4-face :foreground blush)
    (rainbow-delimiters-depth-5-face :foreground zest)
    (rainbow-delimiters-depth-6-face :foreground violet)
    (rainbow-delimiters-depth-7-face :foreground hazy)
    (rainbow-delimiters-depth-8-face :foreground sardine)
    (rainbow-delimiters-depth-9-face :foreground coral)

    ;; Line numbers
    (line-number :foreground base4 :background bg)
    (line-number-current-line :foreground fg :background base2)

    ;; Selection/region
    (region :background selection :foreground fg)

    ;; Cursor
    (cursor :foreground bg :background fg)

    ;; Fringe
    (fringe :foreground base4 :background bg)

    ;; Border
    (border :foreground base3)

    ;; Highlight symbol
    (highlight-symbol-face :background (doom-lighten base2 0.1))

    ;; Highlight line
    (hl-line :background (doom-lighten bg 0.05)))

  ;;;; Base theme variable overrides
  ())

;;; doom-last-utopia-theme.el ends here