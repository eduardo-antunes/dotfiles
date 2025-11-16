Esse repositório contém a minha configuração pessoal de uma coleção de
programas que eu utilizo no dia a dia. São eles:

* `bash`: shell interativo.
* `emacs`: editor de texto gráfico, livre e extensível.
* `foot`: emulador de terminal mínimo para o Wayland.
* `gdb`: depurador para a linguagem C.
* `nvim`: editor de texto de terminal, livre e extensível.
* `tmux`: multiplexador de terminal leve.
* `wezterm`: emulador de terminal multiplataforma e rico em funcionalidades.

O foco definitivo aqui é no Linux, o sistema operacional que eu prefiro
utilizar, mas algumas configurações também funcionam no Windows (se o WSL for
considerado, evidentemente todas funcionam).

Em vez de usar um repositório _bare_ do git ou uma ferramenta como o GNU stow
para administrar os meus _dotfiles_ (isto é, os arquivos de configuração),
escrevi um simples _script_ `bootstrap.sh`. Ele simplesmente gera os links
simbólicos necessários para ativar as configurações neste repositórios; seu uso
está documentado no próprio arquivo.

As mensagens de commit desse repositório seguem um padrão consistente:
modificações que não tenham a ver com uma configuração em particular tem
mensagens que começam com `meta`, enquanto modificações em configurações
específicas tem mensagens que começam com o nome da configuração em questão.
