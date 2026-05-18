# Ashanti Gold Project Color Themes

This document outlines the color palettes and theme configurations used across the project for both light and dark modes.

## 🎨 Core Brand Palettes

Defined in `src/design.css`, these are the foundation of the project's visual identity.

### Ashanti Gold (Primary)
- **Base Color**: `#C4902E`
- **Usage**: Call-to-action buttons, active states, highlights, and icons.

| Weight | Hex Code | Weight | Hex Code |
| :--- | :--- | :--- | :--- |
| **50** | `#fbf8f2` | **600** | `#a67323` |
| **100** | `#f5eedc` | **700** | `#855820` |
| **200** | `#eaddb6` | **800** | `#6d4722` |
| **300** | `#dec588` | **900** | `#5a3b22` |
| **400** | `#d1aa5d` | **950** | `#331e0e` |
| **500** | `#c4902e` | | |

### Ashanti Black (Neutral)
- **Base Color**: `#000000`
- **Usage**: Primary text, structural grounding, and dark mode backgrounds.

| Weight | Hex Code | Weight | Hex Code |
| :--- | :--- | :--- | :--- |
| **50** | `#f6f6f6` | **600** | `#5d5d5d` |
| **100** | `#e7e7e7` | **700** | `#4f4f4f` |
| **200** | `#d1d1d1` | **800** | `#454545` |
| **300** | `#b0b0b0` | **900** | `#3d3d3d` |
| **400** | `#888888` | **950** | `#000000` |
| **500** | `#6d6d6d` | | |

---

## ☀️ Light Mode Configuration
*Defined in `:root` in `src/styles.css`*

| Variable | Value (OKLCH/Hex) | Description |
| :--- | :--- | :--- |
| `--background` | `oklch(0.973 0 180)` | Main page background |
| `--foreground` | `oklch(0.209 0 180)` | Primary text color |
| `--primary` | `oklch(0.209 0 180)` | Primary brand UI color |
| `--secondary` | `oklch(0.94 0 172.405)` | Secondary surfaces/buttons |
| `--muted` | `oklch(0.94 0 172.405)` | Subtle text or backgrounds |
| `--border` | `oklch(0.922 0 168.69)` | Component borders |
| `--sidebar-accent` | `#f5eedc` | Sidebar active background |

---

## 🌙 Dark Mode Configuration
*Defined in `.dark` in `src/styles.css`*

| Variable | Value (Hex) | Description |
| :--- | :--- | :--- |
| `--background` | `#242424` | Dark mode page background |
| `--foreground` | `#e8eaf0` | Light text for dark mode |
| `--primary` | `#e8eaf0` | Primary brand UI color |
| `--secondary` | `#333333` | Secondary dark surfaces |
| `--muted` | `#2e2e2e` | Muted dark backgrounds |
| `--border` | `#3a3a3a` | Dark component borders |
| `--sidebar` | `#202020` | Navigation background |

---

## 🛠 Usage & Design Rules

1. **Accessibility**: Ashanti Gold (`#C4902E`) on White has a contrast ratio of ~3.0:1. Use it primarily for large text or decorative elements on light backgrounds. For small text, use it on Black backgrounds where contrast is significantly higher.
2. **Theming**: The project uses Tailwind CSS with custom variables. Toggle the `.dark` class on the `<html>` or `<body>` tag to switch themes.
3. **Toasts**: Specialized styles for `agc-toast` adapt dynamically to both themes, using `color-mix` to ensure brand consistency while maintaining readability.
