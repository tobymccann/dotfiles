# My macOS Boostrap for software development & business

* On a fresh macOS:

  * Setup for software development entirely with a one-liner 
    ```bash
    curl --silent https://raw.githubusercontent.com/tobymccann/dotfiles/master/bootstrap.sh | bash
    ```

  * Open a Fish shell and execute `compile_vim_plugins` and `install_oh_my_fish` functions.
  * Enter license information for purchased applications.
  * Manually set [un-automatable shortcuts](https://github.com/tobymccann/dotfiles/blob/master/shortcuts/shortcuts.md#un-automatable-shortcuts)

* Execute `bootstrap` function anytime which in turn executes the bootstrapping script.
