import 'package:flutter/material.dart';
import 'package:free_life/pages/accounts/accounts_page.dart';
import 'package:free_life/pages/home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Adicione novas abas aqui no futuro
  static const List<Widget> _pages = [
    HomePage(),
    AccountsPage(),
    // ProfilePage(),
    // RentabilidadePage(),
  ];

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Início',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet_outlined),
      activeIcon: Icon(Icons.account_balance_wallet),
      label: 'Contas',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.show_chart_outlined),
    //   activeIcon: Icon(Icons.show_chart),
    //   label: 'Rentabilidade',
    // ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.person_outline),
    //   activeIcon: Icon(Icons.person),
    //   label: 'Perfil',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mantém o estado de todas as abas vivo (não recria ao trocar)
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _items,
      ),
    );
  }
}
