# Harpwn
Harpoon wanna be

### Instalation

I don't know how other plugin managers work

But here is copy paste for you

```
Plug('c64cosmin/harpwn.vim')
```

### Help

To get more info directly in Vim

```vim
:help harpwn
```

### Easy setup

This is my own configuration

You can assign a buffer to a number by tapping `<Leader>h{num}`

This will assign the current opened buffer to {num}


To get back to that buffer you just press `g{num}`


You can move fast through them using < and >

```vim
nmap <silent> <Leader>H :HarpwnAdd<CR>
nmap <silent> <Leader>h :HarpwnMenu<CR>
nmap <silent> > :HarpwnNext 1<CR>
nmap <silent> < :HarpwnNext -1<CR>
nmap <silent> g1 :HarpwnGo 0<CR>
nmap <silent> g2 :HarpwnGo 1<CR>
nmap <silent> g3 :HarpwnGo 2<CR>
nmap <silent> g4 :HarpwnGo 3<CR>
nmap <silent> g5 :HarpwnGo 4<CR>
nmap <silent> g6 :HarpwnGo 5<CR>
nmap <silent> g7 :HarpwnGo 6<CR>
nmap <silent> g8 :HarpwnGo 7<CR>
nmap <silent> g9 :HarpwnGo 8<CR>
nmap <silent> g0 :HarpwnGo 9<CR>
nmap <silent> <Leader>H1 :HarpwnSet 0<CR>
nmap <silent> <Leader>H2 :HarpwnSet 1<CR>
nmap <silent> <Leader>H3 :HarpwnSet 2<CR>
nmap <silent> <Leader>H4 :HarpwnSet 3<CR>
nmap <silent> <Leader>H5 :HarpwnSet 4<CR>
nmap <silent> <Leader>H6 :HarpwnSet 5<CR>
nmap <silent> <Leader>H7 :HarpwnSet 6<CR>
nmap <silent> <Leader>H8 :HarpwnSet 7<CR>
nmap <silent> <Leader>H9 :HarpwnSet 8<CR>
nmap <silent> <Leader>H0 :HarpwnSet 9<CR>
```

## Self-Promotion

I make video games

[Twitter](http://twitter.com/c64cosmin)

[HomePage](https://stupidrat.com)

## License

Copyright (c) c64cosmin.  Distributed under the same terms as Vim itself.
See `:help license`.
