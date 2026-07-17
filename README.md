# Javen Dotfiles

A lightweight and calm terminal environment for Debian and Ubuntu servers.

Designed for people who spend a lot of time in SSH sessions and prefer a clean, readable, low-saturation terminal experience.

## Features

* Custom Bash prompt with low-saturation colors
* Automatic command output coloring through `grc`
* Nord theme support for `bat`
* Colored `journalctl` output through `ccze`
* grep highlighting
* Preserved colors in `less`
* Handy helpers:

  * `jlog`
  * `jfollow`

### Optional Enhancement

* `vivid` file coloring with `rose-pine-dawn` theme

`vivid` is an optional enhancement.
The terminal works normally without it.

---

## Installation

```bash
git clone https://github.com/zjw27/javen-dotfiles.git

cd javen-dotfiles

./install.sh
```

Apply the configuration:

```bash
source ~/.bashrc
```

---

## Components

The installer will:

1. Install required packages:

   * `grc`
   * `bat`
   * `ccze`

2. Install optional enhancements:

   * `vivid` (x86_64 Linux only)

3. Download and configure:

   * `~/.javenrc`

4. Automatically load the configuration from:

   * `~/.bashrc`

---

## Customization

The main configuration file is:

```bash
~/.javenrc
```

You can modify:

* prompt colors
* aliases
* command wrappers
* vivid themes

For example, to change the vivid theme:

```bash
vivid themes
```

Then update the theme name in `~/.javenrc`.

---

## Requirements

* Debian / Ubuntu based systems
* Bash
* `apt`

Currently tested on:

* x86_64 Linux VPS environments

---

## Philosophy

Keep the system simple.

The goal is not to turn a server into a desktop environment, but to make everyday terminal work more comfortable.

A good shell should disappear into the background:

quiet enough to stay focused,
beautiful enough to enjoy using.
