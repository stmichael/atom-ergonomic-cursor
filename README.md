# Ergonomic key layout for cursor movement in Atom

Some years ago I started using Emacs and [Cabbage](http://senny.github.io/cabbage/) which introduced an alternative key layout to move the cursor. I really started to like the new layout because it limits the unnecessary movements of your hands from the center of the keyboard to the cursor keys and backwards.

When I switched to Atom I couldn't stand being without the ergonomic cursor movement. This project is Cabbages ergonomic cursor movement implementation ported to Atom.

Beware: This package currently only works on OS X.

## Usage

The ergonomic layout uses the keys i, k, j and l to move the cursor. Obviously these keys cannot be overridden directly but in combination with meta keys this turns out to be a powerful feature.

### Simple cursor movement

* `cmd-i`: move the cursor one line up
* `cmd-k`: move the cursor one line down
* `cmd-j`: move the cursor one character to the left
* `cmd-l`: move the cursor one character to the right

### Fast cursor movement

* `shift-cmd-i`: move one page up
* `shift-cmd-k`: move one page down
* `shift-cmd-j`: move to the beginning of the line
* `shift-cmd-l`: move to the end of the line

### Special cursor movement

* `cmd-u`: move one word to the left
* `cmd-o`: move one word to the right
* `shift-cmd-u`: move one paragraph up
* `shift-cmd-o`: move one paragraph down

### Text selection

But how do you select one character to the right? `cmd-l` (move the cursor one character to the right) while holding `shift` is bound another action.

If you are familiar with Emacs you already know the solution. You start by placing a mark at the current cursor position. Then you move the cursor around. Everything between the mark and the current cursor position is selected. Then use the selection as you used it before installing this package.

* `cmd-space`: place the selection mark / remove the mark when placed two times at the same position

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
