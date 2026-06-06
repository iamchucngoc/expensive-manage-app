const List<String> categoryIcons = [
  // Restaurant
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M11 9H9V2H7v7H5V2H3v7c0 2.12 1.66 3.84 3.75 3.97V22h2.5v-9.03C11.34 12.84 13 11.12 13 9V2h-2zM16 6v8h2.5v8H21V2c-2.76 0-5 2.24-5 4"/></svg>',

  
  // Wallet
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M21 7.28V5c0-1.1-.9-2-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14c1.1 0 2-.9 2-2v-2.28A2 2 0 0 0 22 15V9a2 2 0 0 0-1-1.72M20 9v6h-7V9zM5 19V5h14v2h-6c-1.1 0-2 .9-2 2v6c0 1.1.9 2 2 2h6v2z"/><circle cx="16" cy="12" r="1.5" fill="currentColor"/></svg>',

  // Info
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2m0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8s8 3.58 8 8s-3.58 8-8 8m-1-13h2v6h-2zm0 8h2v2h-2z"/></svg>',

  // Shopping Bag (simple)
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M18 6h-2c0-2.21-1.79-4-4-4S8 3.79 8 6H6c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2"/></svg>',

  // Car (simple)
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8z"/></svg>',

  // Document
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2m-5 14H9v-2h6zm0-4H9v-2h6zm0-4H9V8h6z"/></svg>',

  // Shield
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12c5.16-1.26 9-6.45 9-12V5l-9-4z"/></svg>',

  // Clipboard
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1s-1-.45-1-1s.45-1 1-1z"/></svg>',

  // Circle
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2z"/></svg>',

  // Download
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>',
   
   // Cash
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M3 6H21V18H3zM12 8C9.79 8 8 9.79 8 12S9.79 16 12 16 16 14.21 16 12 14.21 8 12 8z"/></svg>',

  // Bank
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 3L2 8V10H22V8M4 12V17H7V12M10 12V17H14V12M17 12V17H20V12M2 19V21H22V19"/></svg>',

  // Credit Card
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M20 4H4C2.9 4 2 4.9 2 6V18C2 19.1 2.9 20 4 20H20C21.1 20 22 19.1 22 18V6C22 4.9 21.1 4 20 4M20 18H4V12H20V18M20 8H4V6H20"/></svg>',

  // Receipt
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M18 17H6V15H18M18 13H6V11H18M18 9H6V7H18M21 3V21L18 19L15 21L12 19L9 21L6 19L3 21V3"/></svg>',

  // Chart Line
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M3 17L9 11L13 15L21 7V17H3Z"/></svg>',

  // Pie Chart
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M11 2V22A10 10 0 0 1 11 2M13 2.05V11H21.95A10 10 0 0 0 13 2.05"/></svg>',

  // Calculator
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M7 2H17A2 2 0 0 1 19 4V20A2 2 0 0 1 17 22H7A2 2 0 0 1 5 20V4A2 2 0 0 1 7 2M7 6V10H17V6M8 12H10V14H8M12 12H14V14H12M16 12H18V14H16"/></svg>',

  // Safe
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 4H20V20H4V4M12 8A4 4 0 0 0 8 12A4 4 0 0 0 12 16A4 4 0 0 0 16 12A4 4 0 0 0 12 8"/></svg>',

  // Piggy Bank
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M19 10C20.11 10 21 10.9 21 12S20.11 14 19 14H18V17H16V19H12V17H8A4 4 0 0 1 4 13V11A4 4 0 0 1 8 7H15A4 4 0 0 1 19 10"/></svg>',

  // Target
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2A10 10 0 1 0 22 12A10 10 0 0 0 12 2M12 6A6 6 0 1 1 6 12A6 6 0 0 1 12 6M12 10A2 2 0 1 0 14 12A2 2 0 0 0 12 10"/></svg>',
 // Shield Check
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2L4 5V11C4 16.55 7.84 21.74 12 23C16.16 21.74 20 16.55 20 11V5M10 17L6 13L7.41 11.59L10 14.17L16.59 7.58L18 9"/></svg>',

  // Transfer
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M15 5L20 10L15 15V11H4V9H15M9 19L4 14L9 9V13H20V15H9"/></svg>',

  // Arrow Up
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 12L5.41 13.41L11 7.83V20H13V7.83L18.59 13.41L20 12L12 4Z"/></svg>',

  // Arrow Down
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M20 12L18.59 10.59L13 16.17V4H11V16.17L5.41 10.59L4 12L12 20Z"/></svg>',

  // Bell
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 22A2 2 0 0 0 14 20H10A2 2 0 0 0 12 22M18 16V11A6 6 0 0 0 6 11V16L4 18V19H20V18"/></svg>',

  // Home
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M10 20V14H14V20H19V12H22L12 3L2 12H5V20"/></svg>',

  // Medical
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M19 8H15V4H9V8H5V14H9V18H15V14H19"/></svg>',

  // Education
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 3L1 9L12 15L21 10.09V17H23V9"/></svg>',

  // Shopping Cart
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M7 18C5.9 18 5 18.9 5 20S5.9 22 7 22 9 21.1 9 20 8.1 18 7 18M17 18C15.9 18 15 18.9 15 20S15.9 22 17 22 19 21.1 19 20 18.1 18 17 18M7.16 14H18.55"/></svg>',

  // Gift
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M20 12V22H4V12M21 7H16.83A3 3 0 0 0 12 3A3 3 0 0 0 7.17 7H3V11H21"/></svg>',

  // Airplane
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M21 16V14L13 9V3.5A1.5 1.5 0 0 0 10 3.5V9L2 14V16L10 13.5V19L8 20.5V22L11.5 21L15 22V20.5L13 19V13.5"/></svg>',

  // Phone
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M6.62 10.79A15.05 15.05 0 0 0 13.21 17.38L15.41 15.18C15.69 14.9 16.08 14.82 16.43 14.93"/></svg>',

  // Wifi
  '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 18A2 2 0 0 1 14 20A2 2 0 0 1 12 22A2 2 0 0 1 10 20A2 2 0 0 1 12 18M12 14A6 6 0 0 1 18 20H16A4 4 0 0 0 12 16"/></svg>',
];