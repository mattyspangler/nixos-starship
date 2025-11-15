# Spacemacs Chrome Theme

A Chrome theme based on the elegant Spacemacs color scheme by Nasser Alshammari.

![Spacemacs Theme](https://github.com/nashamri/spacemacs-theme)

## Colors Used

This theme implements the beautiful Spacemacs dark color scheme:

- **Background**: #292b2e
- **Secondary background**: #212026
- **Border/Purple**: #5d4d7a
- **Base text**: #b2b2b2
- **Blue accent**: #4f97d7
- **Green**: #67b11d
- **Red**: #f2241f
- **Yellow**: #b1951d

## Installation Instructions

### Method 1: Install from directory

1. Download this entire directory
2. Extract all images from the `ready-icons.html` file into the `images` folder (open the HTML file in any browser and click the download buttons)
3. Open Chrome and navigate to `chrome://extensions/`
4. Enable "Developer mode" using the toggle in the top-right corner
5. Click "Load unpacked" and select the `spacemacs-chrome-theme` directory
6. The theme will be applied immediately

### Method 2: Package as CRX

1. Follow steps 1-2 from Method 1
2. Open Chrome and navigate to `chrome://extensions/`
3. Enable "Developer mode"
4. Click "Pack extension" and select the `spacemacs-chrome-theme` directory
5. This will create a .crx file that you can distribute or install on other machines

## Files Included

- **manifest.json**: Core extension file defining theme properties and metadata
- **images/**: Directory containing theme icons and background images
- **create-icons.html**: HTML tool to view and create theme icon SVGs
- **generate-icons.js**: Node.js script that can generate PNG icons (requires canvas package)
- **ready-icons.html**: HTML file with embedded base64 images for quick download