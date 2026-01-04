# FriendTimeTracker

A lightweight macOS menu bar app that shows the current time for your friends in different timezones.

![macOS 14+](https://img.shields.io/badge/macOS-14%2B-blue)
![Swift 5](https://img.shields.io/badge/Swift-5-orange)

## Features

- Lives in your menu bar (no Dock icon)
- Add friends with their timezone
- See everyone's local time at a glance
- Drag to reorder friends
- Launch at login option
- Data persists locally

## Installation

### Option 1: Build from Source (Recommended)

**Requirements:** Xcode 15+ and macOS 14+

```bash
git clone https://github.com/YOUR_USERNAME/FriendTimeTracker.git
cd FriendTimeTracker
open FriendTimeTracker.xcodeproj
```

Then in Xcode:
1. Select your Team in Signing & Capabilities (or use "Sign to Run Locally")
2. Press `Cmd+R` to build and run
3. The globe icon appears in your menu bar

To install permanently:
1. `Cmd+Shift+R` (Run without debugging) or Product → Archive → Distribute App
2. Move the `.app` to `/Applications`

### Option 2: Download Release

Download the latest `.zip` from [Releases](https://github.com/YOUR_USERNAME/FriendTimeTracker/releases), unzip, and move to `/Applications`.

**Note:** Since the app isn't notarized, you'll need to right-click → Open on first launch, then click "Open" in the dialog.

## Usage

1. Click the globe icon in menu bar
2. Click **Settings** to add friends
3. Click **+** to add a friend (name + timezone)
4. Enable **Launch at Login** to auto-start

## Data Storage

Friends are stored in UserDefaults at:
```
~/Library/Preferences/com.friendtimetracker.app.plist
```

To reset: `defaults delete com.friendtimetracker.app`

## License

MIT License - see [LICENSE](LICENSE)
