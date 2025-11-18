;;; doom-last-utopia-theme.el --- A dark theme inspired by the Charmtone/Crush color palette -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Added: November 2025
;; Author: Matty Spangler <https://github.com/mattyspangler>
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

(let ((charple "#6B50FF") ;; Purple
      (dolly "#FF60FF") ;; Pink
      (ripple "#00D9FF") ;; Cyan
      (blush "#FF388B") ;; Red-Pink
      (marmalade "#FFA864") ;; Orange
      (zest "#E8FE96") ;; Yellow-Green
      (bg "#2d2c35") ;; BBQ (Lighter Background)
      (bg-alt "#201F26") ;; Pepper (Base Background)
      (subtle-bg "#3A3943") ;; Charcoal (Subtle Background)
      (overlay-bg "#4D4C57") ;; Iron (Overlay Background)
      (fg "#DFDBDD") ;; Ash (Base Foreground)
      (muted-fg "#858392") ;; Squid (Muted Foreground)
      (half-muted-fg "#BFBCC8") ;; Smoke (Half-Muted Foreground)
      (subtle-fg "#605F6B") ;; Oyster (Subtle Foreground)
      (selected-fg "#F1EFEF") ;; Salt (Selected Foreground)
      (butter "#FFFAF1") ;; White
      (cement "#A0A0A0")
      (fuzz "#B3B3B3")
      (slate "#737373")
      (sardine "#4FBEFE") ;; Light Blue
      (damson "#007AB8") ;; Dark Blue
      (malibu "#00A4FF") ;; Medium Blue
      (mustard "#F5EF34") ;; Yellow
      (citron "#E8FF27")
      (julep "#00FFB2") ;; Green
      (guac "#12C78F") ;; Dark Green
      (bok "#68FFD6") ;; Light Green
      (zinc "#10B1AE") ;; Teal-green
      (turtle "#0ADCD9") ;; Bright cyan
      (lichen "#5CDFEA") ;; Light cyan-blue
      (pickle "#00A475") ;; Git addition
      (gator "#18463D") ;; Dark green (diff background)
      (spinach "#1C3634") ;; Very dark green (diff background)
      (pom "#AB2454") ;; Git deletion
      (steak "#582238") ;; Dark red (diff background)
      (toast "#412130") ;; Very dark red (diff background)
      (coral "#FF577D")
      (sriracha "#EB4268") ;; Dark Red
      (salmon "#FF7F90") ;; Light Red
      (cherry "#FF388B")
      (violet "#C259FF")
      (mauve "#D46EFF")
      (grape "#7134DD")
      (plum "#9953FF")
      (urchin "#C337E0") ;; Deep purple
      (mochi "#EB5DFF") ;; Light purple-pink
      (lilac "#F379FF") ;; Bright lilac
      (prince "#9C35E1") ;; Deep purple-blue
      (orchid "#AD6EFF") ;; Light purple-blue
      (jelly "#4A30D9") ;; Deep blue-purple
      (hazy "#8B75FF") ;; Light purple-blue
      (ox "#3331B2") ;; Deep navy
      (sapphire "#4949FF") ;; Bright blue
      (guppy "#7272FF") ;; Light blue
      (oceania "#2B55B3") ;; Ocean blue
      (thunder "#4776FF") ;; Electric blue
      (anchovy "#719AFC") ;; Steel blue
      (coral-pink "#FF577D")
      (salmon-pink "#FF7F90")
      (tuna "#FF6DAA")
      (cumin "#BF976F") ;; Warm brown-orange
      (tang "#FF985A") ;; Bright orange
      (yam "#FFB587") ;; Light orange
      (paprika "#D36C64") ;; Dusty red-orange
      (bengal "#FF6E63") ;; Bright orange-red
      (uni "#FF937D") ;; Soft salmon
      (chili "#E23080") ;; Deep pink-red
      (macaron "#E940B0") ;; Bright magenta
      (pony "#FF4FBF") ;; Hot pink
      (cheeky "#FF79D0") ;; Light magenta
      (flamingo "#F947E3") ;; Bright pink-purple
      (blush-light "#FF84FF")) ;; Light pink-magenta

  (def-doom-theme doom-last-utopia
    "A dark theme inspired by the Charmtone/Crush color palette"

    ;; Color palette
    ;; name        default   256       16
    ((bg         bg-alt)
     (fg         fg)
     (bg-alt     bg-alt)
     (fg-alt     half-muted-fg)

     (base0      bg-alt)
     (base1      bg)
     (base2      subtle-bg)
     (base3      overlay-bg)
     (base4      subtle-fg)
     (base5      muted-fg)
     (base6      half-muted-fg)
     (base7      fg)
     (base8      selected-fg)

     (grey       muted-fg)
     (red        sriracha)
     (orange     tang)
     (green      guac)
     (teal       zinc)
     (yellow     zest)
     (blue       malibu)
     (dark-blue  damson)
     (magenta    dolly)
     (violet     violet)
     (cyan       ripple)
     (dark-cyan  turtle)

     ;; Last Utopia specific colors
     (charple    charple)
     (dolly      dolly)
     (ripple     ripple)
     (blush      blush)
     (zest       zest)
     (marmalade  marmalade)

     ;; Additional colors for variety
     (hazy       hazy)
     (sardine    sardine)
     (julep      julep)
     (yam        yam)
     (coral      coral)

     ;; Face categories -- required for all themes
     (highlight      malibu)
     (vertical-bar   charple)
     (selection      charple)
     (builtin        lilac)
     (comments       (if doom-last-utopia-brighter-comments base5 base4))
     (doc-comments   (doom-lighten (if doom-last-utopia-brighter-comments base5 base4) 0.25))
     (constants      mochi)
     (functions      green)
     (keywords       malibu)
     (methods        cyan)
     (operators      tang)
     (type           yellow)
     (strings        marmalade)
     (variables      fg)
     (numbers        julep)
     (region         (doom-lighten base2 0.15))
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
    ((paren-face-match &override) :foreground malibu :background base3 :weight 'bold)
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

    ;; Tab bar
    (tab-bar :background bg-alt :foreground fg)
    (tab-bar-tab :background bg :foreground fg :weight 'bold)
    (tab-bar-tab-inactive :background bg-alt :foreground base5)
    (tab-line :background bg-alt :foreground fg)
    (tab-line-tab :background bg :foreground fg :weight 'bold)
    (tab-line-tab-inactive :background bg-alt :foreground base5)

    ;; Centaur tabs
    (centaur-tabs-active-bar-face :background charple :foreground fg)
    (centaur-tabs-default :background bg-alt :foreground base5)
    (centaur-tabs-selected :background bg :foreground fg :weight 'bold)
    (centaur-tabs-unselected :background bg-alt :foreground base5)

    ;; Syntax highlighting
    ((font-lock-comment-face &override)
     :foreground comments
     :background (if doom-last-utopia-comment-bg (doom-darken bg 0.05)))
    ((font-lock-doc-face &override)
     :foreground doc-comments :slant 'italic)
    (font-lock-string-face :foreground strings)
    (font-lock-constant-face :foreground constants :weight 'bold)
    (font-lock-function-name-face :foreground functions :weight 'bold)
    (font-lock-keyword-face :foreground keywords :weight 'bold)
    (font-lock-type-face :foreground type :slant 'italic)
    (font-lock-variable-name-face :foreground variables)
    (font-lock-builtin-face :foreground builtin :weight 'bold)
    (font-lock-number-face :foreground numbers :weight 'bold)

    ;; Shell prompt symbols
    (sh-heredoc :foreground green :weight 'bold)
    (shell-prompt-face :foreground green :weight 'bold)
    (comint-highlight-prompt :foreground green :weight 'bold)
    (eshell-prompt :foreground green :weight 'bold)
    (term :foreground green :weight 'bold)

     ;; Company completions
     (company-tooltip-selection :background selection)
     (company-tooltip-common :foreground malibu)

     ;; Search
     (isearch :foreground base0 :background yellow)
     (lazy-highlight :foreground yellow :background base3)

     ;; Ivy/Vertico/Selectrum
     (ivy-current-match :background selection)
     (ivy-match-required-face :foreground red)
     (ivy-confirm-face :foreground green)
     (ivy-remote :foreground cyan)

     ;; Which-key
     (which-key-key :foreground malibu)
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
     (org-level-1 :foreground malibu :weight 'bold :height 1.2)
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
     (org-link :foreground malibu :underline t)
     (org-code :background base3 :foreground sardine)
     (org-block :background base2 :foreground fg)
     (org-block-begin-line :background base2 :foreground base5)
     (org-block-end-line :background base2 :foreground base5)

     ;; Markdown
     (markdown-header-face-1 :foreground malibu :weight 'bold :height 1.2)
     (markdown-header-face-2 :foreground dolly :weight 'bold :height 1.1)
     (markdown-header-face-3 :foreground ripple :weight 'bold)
     (markdown-header-face-4 :foreground blush :weight 'bold)
     (markdown-header-face-5 :foreground zest :weight 'bold)
     (markdown-header-face-6 :foreground violet :weight 'bold)
     (markdown-link-face :foreground malibu :underline t)
     (markdown-code-face :background base3 :foreground sardine)

     ;; Git/Version control
     (git-commit-comment-action :foreground magenta)
     (git-commit-comment-branch :foreground blue)
     (git-commit-comment-file :foreground cyan)
     (git-commit-comment-heading :foreground yellow :weight 'bold)
     (git-commit-summary :foreground fg)
     (git-commit-nonempty-second-line :foreground fg)

     ;; Diff
     (diff-added :foreground pickle :background gator)
     (diff-removed :foreground pom :background steak)
     (diff-changed :foreground (doom-lighten yellow 0.2) :background (doom-darken yellow 0.7))
     (diff-refine-added :foreground pickle :background gator :weight 'bold)
     (diff-refine-removed :foreground pom :background steak :weight 'bold)
     (diff-refine-changed :foreground yellow :background (doom-darken yellow 0.6) :weight 'bold)

     ;; Magit
     (magit-section-heading :foreground malibu :weight 'bold)
     (magit-section-highlight :background base2)
     (magit-hash :foreground cyan)
     (magit-branch-local :foreground green)
     (magit-branch-remote :foreground orange)
     (magit-diff-added :foreground pickle :background gator)
     (magit-diff-removed :foreground pom :background steak)
     (magit-diff-context :foreground base5)
     (magit-diff-hunk-heading :background base3 :foreground fg :weight 'bold)

     ;; Treemacs
     (treemacs-root-face :foreground malibu :weight 'bold)
     (treemacs-directory-face :foreground blue)
     (treemacs-file-face :foreground fg)
     (treemacs-git-modified-face :foreground orange)
     (treemacs-git-added-face :foreground green)
     (treemacs-git-conflict-face :foreground red)
     (treemacs-git-untracked-face :foreground yellow)
     (treemacs-selected-face :background charple :foreground fg :weight 'bold)

     ;; Neotree
     (neo-dir-link-face :foreground blue :weight 'bold)
     (neo-file-link-face :foreground fg)
     (neo-root-dir-face :foreground malibu :weight 'bold)
     (neo-expand-btn-face :foreground base5)

     ;; Minibuffer/Completions
     (completions-annotations :foreground base5)
     (completions-common-part :foreground malibu)
     (completions-first-difference :foreground orange :weight 'bold)

     ;; Error/warning/success faces
     (error :foreground red :weight 'bold)
     (warning :foreground yellow :weight 'bold)
     (success :foreground green :weight 'bold)

     ;; Tooltip
     (tooltip :background base3 :foreground fg)

     ;; Show-paren
     (show-paren-match :foreground malibu :background base3 :weight 'bold)
     (show-paren-mismatch :foreground red :background base3 :weight 'bold)

     ;; Rainbow delimiters
     (rainbow-delimiters-depth-1-face :foreground hazy :weight 'bold)
     (rainbow-delimiters-depth-2-face :foreground julep)
     (rainbow-delimiters-depth-3-face :foreground sardine)
     (rainbow-delimiters-depth-4-face :foreground orchid)
     (rainbow-delimiters-depth-5-face :foreground guac)
     (rainbow-delimiters-depth-6-face :foreground blush)
     (rainbow-delimiters-depth-7-face :foreground zest)
     (rainbow-delimiters-depth-8-face :coral-pink)
     (rainbow-delimiters-depth-9-face :foreground violet)

     ;; Line numbers
     (line-number :foreground base4 :background bg)
     (line-number-current-line :foreground fg :background base2)

     ;; Selection/region
     (region :background selection :foreground fg)

     ;; Cursor
     (cursor :foreground bg-alt :background dolly)

     ;; Fringe
     (fringe :foreground base4 :background bg)

     ;; Border
     (border :foreground base3)

     ;; Highlight symbol
     (highlight-symbol-face :background (doom-lighten base2 0.1))

     ;; Highlight line
     (hl-line :background (doom-lighten bg 0.05))

     ;; Cider faces
     (cider-error-highlight-face :inherit 'font-lock-warning-face :underline `(:style wave :color ,red))
     (cider-warning-highlight-face :inherit 'font-lock-warning-face :underline `(:style wave :color ,yellow))
     (spell-fu-incorrect-face :inherit 'error :underline `(:style wave :color ,red)))

    ;;;; Base theme variable overrides
    ()))

;;; doom-last-utopia-theme.el ends here
