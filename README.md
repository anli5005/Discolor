# Discolor
A hacky macOS utility that manages your [Discord](https://discordapp.com) color scheme. It supports macOS Catalina and later.

## Installation
1. Drag **Discolor.app** to your **Applications** folder.
2. Open Discolor. An icon (☯️) should appear in your status bar.
3. Open System Preferences, navigate to **Security & Privacy**, click on the **Privacy** tab, and grant Discolor **Accessibility** permissions.
4. Turn on the switch to have Discolor automatically change Discord's color scheme when the system apparance changes.
5. Add Discolor as a Login Item in the **Users & Groups** pane of System Preferences if desired.

## Caveats
* Pre-release versions of Discolor may not work reliably.
* Discolor will not change Discord's color scheme if Discord is not running.

## How it Works
To change Discord's color scheme, Discolor first activates Discord's window. It then sends Discord a series of keyboard shortcuts which:
1. Open the Quick Switcher
2. Open Preferences
3. Close the Quick Switcher
4. <kbd>tab</kbd> to the Appearance page
5. <kbd>tab</kbd> to the desired color scheme
6. Close Preferences
Following this, Discolor will attempt to re-activate your most recently used app.

Bear in mind that this is a hacky solution as Discord currently lacks official support for programmatically changing the color scheme. It will probably fail half of the time.
