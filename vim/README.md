#Will's Amazing Vim Configuration Files!

One of the best documented .vimrc files on the web, custom tailored to .nodejs development.

> Note: This is now a lie. Documentation has drifted away from the state of the repo

##Folder structure

* `autoload` -- http://learnvimscriptthehardway.stevelosh.com/chapters/53.html
   * `pathogen.vim` -- https://github.com/tpope/vim-pathogen
* `bundle` -- global scripts loaded by pathogen. Currently empty.
* `colors` -- http://vim.wikia.com/wiki/Change_the_color_scheme
   * `molokai.vim` -- https://github.com/tomasr/molokai
* `ftplugin` -- http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
   * `python.vim` -- https://wiki.python.org/moin/Vim
* `indent` -- Where all indentation rules go in the form `filetype.vim`
   * `html.vim` -- https://code.google.com/p/web-indent/
   * `javascript.vim` -- https://code.google.com/p/web-indent/
* `nodejs` -- All node specific configurations. This will be loaded by pathogen.
   * `jshint.vim` -- https://github.com/walm/jshint.vim
   * `node.vim` -- https://github.com/moll/vim-node
   * `vim-javascript-syntax` -- https://github.com/jelera/vim-javascript-syntax
   * `vim-nodejs-complete` -- https://github.com/myhere/vim-nodejs-complete
