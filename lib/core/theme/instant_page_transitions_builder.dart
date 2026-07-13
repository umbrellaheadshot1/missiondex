import 'package:flutter/material.dart';

/// Transição de página "instantânea" (sem animação), usada quando o
/// Modo Missão está ativo — atende ao pedido de "diminuir animações
/// para abrir tudo mais rapidamente".
class InstantPageTransitionsBuilder extends PageTransitionsBuilder {
  const InstantPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
