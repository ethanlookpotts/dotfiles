# Termius on iPhone

> **Work in progress.** Not yet validated end-to-end against a real iPhone. Known rough spot: pasting the moonfly palette into Termius's color editor is tedious and a smoother path hasn't been found. Other corners likely need work too.

A complete setup for reaching the iTerm2 / tmux / Neovim stack in this repo from an iPhone over Tailscale. iPhone-only client. No iPad, no Bluetooth keyboard. No Mosh. Free Termius tier throughout.

The follow-along works directly from the phone once the Mac prep is done.

## Mac prep (one-time)

Open System Settings on the Mac and do all three:

1. **Remote Login.** General → Sharing → Remote Login: on. Verify with `ssh "$USER"@localhost` from a terminal.
2. **Stay awake for incoming SSH.** Battery (or Energy Saver on a desktop Mac) → Options. Set "Prevent automatic sleeping when display is off" and "Wake for network access" both on. A closed-lid laptop on battery sleeps regardless of these toggles. Plug it in or run Amphetamine if you need 24/7 reach.
3. **Tailscale SSH.** In Terminal: `tailscale up --ssh`. This authenticates connections through your tailnet ACL and removes the need for SSH keys. It's the cleanest path to a phone-only setup.

## iPhone steps

Each step below is done in the Termius app.

### 1. Install

- Termius (App Store)
- Tailscale (App Store), signed in with the same account as the Mac

### 2. Add the host

Termius → Hosts → tap +.

- **Address:** the Mac's Tailscale MagicDNS short name (`mac` if Magic DNS is on; otherwise `mac.tailnet-xxxx.ts.net`)
- **Username:** your macOS account name
- **Password / key:** leave empty (Tailscale SSH handles auth)

Save. Tap the host. Accept the host fingerprint. You should land in a shell.

### 3. Set the auto-attach command

Edit the host. In the Startup Snippet (or "Run command on connect") field, paste:

```
work mobile
```

That calls the `work` function from `.zshrc`. It creates session `mobile` if missing and attaches if it exists. If your version of Termius doesn't expose this field, type `work mobile` after each connect; zsh autosuggestions will let you accept it after two characters.

### 4. Customize the keys strip

Open any host. Bring up the keyboard. Tap the strip above it, then tap the gear (or Edit / pencil). The strip is the most important piece of the setup.

Set these four groups, in order:

**Group 1, modifiers and movement:** `Esc` `Ctrl` `Alt` `Tab`

**Group 2, arrows:** `←` `↓` `↑` `→`

**Group 3, shell symbols:** `~` `/` `-` `_`

**Group 4, code symbols:** `|` `\` `:` `;`

Drag groups to reorder; Group 1 should be leftmost so it's what you see first. If Termius preloaded other groups, delete them with the red minus.

### 5. Set the moonfly theme

Termius → Settings → Color schemes → New scheme. Name it `moonfly`.

Paste these hex values:

| Slot                   | Hex       |
|------------------------|-----------|
| Background             | `#080808` |
| Foreground             | `#BDBDBD` |
| Cursor                 | `#9E9E9E` |
| ANSI 0  black          | `#323437` |
| ANSI 1  red            | `#FF5D5D` |
| ANSI 2  green          | `#8CC85F` |
| ANSI 3  yellow         | `#E3C78A` |
| ANSI 4  blue           | `#80A0FF` |
| ANSI 5  magenta        | `#CF87E8` |
| ANSI 6  cyan           | `#79DAC8` |
| ANSI 7  white          | `#C6C6C6` |
| ANSI 8  bright black   | `#949494` |
| ANSI 9  bright red     | `#FF5189` |
| ANSI 10 bright green   | `#36C692` |
| ANSI 11 bright yellow  | `#C6C684` |
| ANSI 12 bright blue    | `#74B2FF` |
| ANSI 13 bright magenta | `#AE81FF` |
| ANSI 14 bright cyan    | `#85DC85` |
| ANSI 15 bright white   | `#E4E4E4` |

Save. Edit the host → Color scheme → moonfly.

### 6. Install MesloLGS NF

Powerlevel10k needs a Nerd Font. Without it, the prompt renders as boxes.

1. In Safari on the iPhone, open this URL and tap to download:
   `https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf`
2. Tap the download in Safari → Open in Files. Save it anywhere.
3. Open the Files app, tap the `.ttf`, tap Install. Confirm under Settings → General → VPN & Device Management.
4. Termius → Settings → Terminal → Font → MesloLGS NF Regular.

Repeat for Bold, Italic, and Bold Italic if you want full coverage. The single Regular file is enough for daily use.

### 7. Terminal and security tweaks

Termius → Settings → Terminal:
- Terminal type: `xterm-256color`
- Keep awake while connected: on

Termius → Settings → Security:
- Touch ID / Face ID for the keychain: on

Edit host → SSH options:
- Keep alive interval: `30`

### 8. Connect and verify

Tap the host. You should land in a tmux session named `mobile`, with the Powerlevel10k prompt rendering icons (no boxes), in the moonfly palette.

Test the keys:

- `Ctrl` then `a` then `c` opens a new tmux window
- `Ctrl` then `h` / `j` / `k` / `l` moves between tmux panes (works the same inside Neovim thanks to smart-splits)
- `Alt` then `h` / `j` / `k` / `l` resizes panes
- `Esc` then `:wq` closes a Neovim buffer
- Pinch to zoom font size

If P10k shows boxes instead of icons, the font didn't apply; redo step 6.
If colors look default, the host isn't on moonfly; redo step 5 and reattach.

## Why this keys layout

- `Ctrl` carries your tmux prefix (`C-a`) and pane nav (`C-h/j/k/l`). Tap once, then tap a letter; Termius sends `C-letter`. There is no lock mode and no need for one.
- `Alt` carries pane resize (`M-h/j/k/l`).
- `Esc` is the most-pressed key in Neovim.
- `Tab` is shell completion.
- `~` `/` `-` `_` cover paths and shell flags.
- `|` `\` `:` `;` cover pipes, escapes, Neovim command mode, and the `;` repeat motion.

The iOS keyboard already gives you digits and most punctuation behind the `123` page. The strip covers what iOS doesn't: `Esc`, `Ctrl`, `Alt`, `Tab`, `~`.
