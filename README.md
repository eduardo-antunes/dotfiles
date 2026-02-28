> [!NOTE] Decidi passar os meus arquivos de configuração para um novo
> repositório no codeberg; você pode encontrá-lo
> [aqui](https://codeberg.org/eduardo-antunes/dotfiles). Este repositório ficará
> apenas como um registro histórico.

Esse repositório contém configurações para alguns programas que eu uso no
dia a dia:

* `bash`: shell interativo.
* `emacs`: editor de texto gráfico.
* `foot`: emulador de terminal mínimo para o Wayland.
* `gdb`: depurador para a linguagem C.
* `nvim`: editor de texto de terminal.
* `tmux`: multiplexador de terminal.
* `wezterm`: emulador de terminal multiplataforma.

O foco definitivo aqui é no Linux, o sistema operacional que eu prefiro
utilizar, mas algumas configurações também funcionam no Windows (se o WSL for
considerado, todas funcionam).

O script `bootstrap.sh` serve para gerar links simbólicos para as configurações
nesse repositório nos lugares onde os programas esperam encontrá-los. Isso
facilita carregar os arquivos em diferentes sistemas e mantém os dotfiles em um
diretório centralizado, facilitando sua edição.
