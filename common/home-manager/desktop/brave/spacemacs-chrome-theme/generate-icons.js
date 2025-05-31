// This script can be run in a browser console or Node.js with canvas support
// It generates icon PNGs for the Spacemacs Chrome theme

const fs = require('fs');
const { createCanvas } = require('canvas');

// Spacemacs Colors
const colors = {
  bg1: '#292b2e',      // Background
  border: '#5d4d7a',   // Border/purple
  blue: '#4f97d7',     // Blue accent
  base: '#b2b2b2',     // Text color
  bg2: '#212026',      // Secondary background
};

// Generate icons in different sizes
const sizes = [16, 32, 48, 128];

for (const size of sizes) {
  // Create canvas with the required size
  const canvas = createCanvas(size, size);
  const ctx = canvas.getContext('2d');
  
  // Draw background
  ctx.fillStyle = colors.bg1;
  ctx.fillRect(0, 0, size, size);
  
  // Draw circle
  ctx.beginPath();
  ctx.arc(size/2, size/2, size * 0.375, 0, 2 * Math.PI);
  ctx.fillStyle = colors.border;
  ctx.fill();
  ctx.lineWidth = Math.max(1, size * 0.02);
  ctx.strokeStyle = colors.blue;
  ctx.stroke();
  
  // Draw cross (plus sign)
  ctx.beginPath();
  ctx.moveTo(size * 0.3, size/2);
  ctx.lineTo(size * 0.7, size/2);
  ctx.lineWidth = Math.max(1, size * 0.02);
  ctx.strokeStyle = colors.base;
  ctx.stroke();
  
  ctx.beginPath();
  ctx.moveTo(size/2, size * 0.3);
  ctx.lineTo(size/2, size * 0.7);
  ctx.lineWidth = Math.max(1, size * 0.02);
  ctx.strokeStyle = colors.base;
  ctx.stroke();
  
  // Save to file
  const buffer = canvas.toBuffer('image/png');
  fs.writeFileSync(`images/icon${size}.png`, buffer);
  console.log(`Generated icon${size}.png`);
}

// Generate theme background images
function generateThemeFrame() {
  const width = 1, height = 1;  // Just a 1x1 pixel for solid background
  const canvas = createCanvas(width, height);
  const ctx = canvas.getContext('2d');
  
  ctx.fillStyle = colors.bg1;
  ctx.fillRect(0, 0, width, height);
  
  const buffer = canvas.toBuffer('image/png');
  fs.writeFileSync('images/theme_frame.png', buffer);
  console.log('Generated theme_frame.png');
}

function generateNtpBackground() {
  const width = 1, height = 1;  // Just a 1x1 pixel for solid background
  const canvas = createCanvas(width, height);
  const ctx = canvas.getContext('2d');
  
  ctx.fillStyle = colors.bg2;
  ctx.fillRect(0, 0, width, height);
  
  const buffer = canvas.toBuffer('image/png');
  fs.writeFileSync('images/theme_ntp_background.png', buffer);
  console.log('Generated theme_ntp_background.png');
}

generateThemeFrame();
generateNtpBackground();

console.log('All icons and theme images generated successfully!');