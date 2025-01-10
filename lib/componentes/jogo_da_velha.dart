import 'package:flutter/material.dart';

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({super.key});

  @override
  State<JogoDaVelha> createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> _tabuleiro = List.filled(9, '');
  String _jogador = 'X';
  String _mensagem = '';
  bool _contraMaquina = true;

  void _mudancadejogador() {
    setState(() {
      _jogador = _jogador == 'X' ? 'O' : 'X';
    });
  }

  bool _verificarVencedor(String jogador) {
    const posicoesDeVitoria = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var posicao in posicoesDeVitoria) {
      if (_tabuleiro[posicao[0]] == jogador &&
          _tabuleiro[posicao[1]] == jogador &&
          _tabuleiro[posicao[2]] == jogador) {
        _mostrarVencedor(jogador);
        return true;
      }
    }

    if (!_tabuleiro.contains('')) {
      _mostrarVencedor('Empate');
      return true;
    }
    return false;
  }

  void _mostrarVencedor(String jogador) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            jogador == 'Empate' ? 'Empate!' : 'Vencedor: $jogador',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _reiniciarJogo();
                },
                child: const Text('Reiniciar'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _reiniciarJogo() {
    setState(() {
      _tabuleiro = List.filled(9, '');
      _jogador = 'X';
      _mensagem = '';
    });
  }

  int? _encontrarJogada(String jogador) {
    const posicoesDeVitoria = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var posicao in posicoesDeVitoria) {
      String a = _tabuleiro[posicao[0]];
      String b = _tabuleiro[posicao[1]];
      String c = _tabuleiro[posicao[2]];

      if ([a, b, c].where((e) => e == jogador).length == 2 &&
          [a, b, c].contains('')) {
        return posicao.firstWhere((e) => _tabuleiro[e] == '');
      }
    }
    return null;
  }

  void _jogadaMaquina() {
    int? jogada;

    jogada = _encontrarJogada('O');
    if (jogada != null) {
      setState(() {
        _tabuleiro[jogada!] = 'O';
      });
      if (_verificarVencedor('O')) return;
      _mudancadejogador();
      return;
    }

    jogada = _encontrarJogada('X');
    if (jogada != null) {
      setState(() {
        _tabuleiro[jogada!] = 'O';
      });
      _mudancadejogador();
      return;
    }

    if (_tabuleiro[4] == '') {
      setState(() {
        _tabuleiro[4] = 'O';
      });
      _mudancadejogador();
      return;
    }

    for (int i = 0; i < _tabuleiro.length; i++) {
      if (_tabuleiro[i] == '') {
        setState(() {
          _tabuleiro[i] = 'O';
        });
        _mudancadejogador();
        return;
      }
    }
  }

  void _jogada(int index) {
    if (_tabuleiro[index] == '' && _mensagem == '') {
      setState(() {
        _tabuleiro[index] = _jogador;
        if (!_verificarVencedor(_jogador)) {
          _mudancadejogador();
          if (_contraMaquina && _jogador == 'O') {
            Future.delayed(const Duration(milliseconds: 500), () {
              _jogadaMaquina();
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 108, 14, 14),
        actions: [
          DropdownButton<bool>(
            value: _contraMaquina,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  _contraMaquina = value;
                  _reiniciarJogo();
                });
              }
            },
            dropdownColor: const Color.fromARGB(255, 114, 31, 31),
            icon: const Icon(Icons.settings, color: Colors.white),
            items: const [
              DropdownMenuItem(value: true, child: Text('Contra Máquina')),
              DropdownMenuItem(value: false, child: Text('2 Jogadores')),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _jogada(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _tabuleiro[index],
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: _tabuleiro[index] == 'X'
                              ? Colors.red
                              : _tabuleiro[index] == 'O'
                                  ? Colors.green
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _reiniciarJogo,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Reiniciar Jogo',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
