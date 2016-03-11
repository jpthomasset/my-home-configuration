# Emacs cheat sheet

## General

* `C-x C-c` Exit
* `C-g` Abort current command/keys (Alternate `ESC-ESC-ESC`)
* `M-x` Execute a command
* `M-:` Evaluate an expression
* `C-h c <keys>` Get one line help for the given keys
* `C-h k <keys>` Get full help for the keys
* `C-h f <function>` Describe the given function (help)
* `C-u <N> <keys>` Repeat <keys> N times

## Navigation

* `C-v` Scroll one page down
* `M-v` Scroll one page up
* `C-l` Scroll so cursor is centerd (repeat for top, repeat again for bottom)
* `C-a` / `C-e` Move to Begin / End of **line**
* `M-a` / `M-e` Move to Begin / End of **sentence**
* `M-<` / `M->` Move to Begin / End of **file**

## Search

* `C-s` Forward Search (repeat for next)
* `C-r` Backward Search (repeat for previous)

## Edit

* `C-d` Delete char
* `M-d` Delete word
* `C-k` Delete end of line (kill) 
* `M-k` Delete end of paragraph (kill)
* `C-w` Cut selection
* `M-w` Copy selection
* `C-y` Yank
  * `M-y` While yanking, cycle previous deleted data
* `C-/` Cancel/undo (Alternate `C-x u`)

## File / Buffers

* `C-x C-f` Open file
* `C-x C-s` Save current buffer
* `C-x C-w` Save current buffer in new file (write)
* `C-x k` Kill current buffer
* `C-x s` Save all buffers
* `C-x C-b` List buffers
* `C-x b` Switch to buffer by name or create one

## Window

* `C-x 1` Only one window
* `C-x 2` Split horizontaly
* `C-x 3` Split verticaly
* `C-x o` Focus on other window

## Printing
Available through the following functions
* `pr-ps-buffer-preview` Preview print the current buffer
* `pr-ps-buffer-print` Print the current buffer
* `pr-ps-region-preview` Preview print the selected region
* `pr-ps-region-print` Print the selected region

## Custom defined (see init.el)
* `C-xg` Open URL under the cursor in your default browser

## Package management

* `M-x list-packages` List available packages

...Inside package list:
* `i` to select package to install
* `x` to execute installation of selected packages


## Ensime
* `C-c C-b s` Start sbt
* `C-c C-b c` Compile
* `C-c C-b r` Run
* `C-c C-v z` Start REPL

### Installed packages
* elpa/markdown-mode
* elpa/monokai-theme
* elpa/php-mode
* ac-php
* elpa/js2-mode
* elpa/jdee
* scala-mode2
* sbt-mode
