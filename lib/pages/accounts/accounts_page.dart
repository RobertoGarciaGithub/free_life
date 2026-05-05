import 'package:flutter/material.dart';
import 'package:free_life/models/account.dart';
import 'package:free_life/providers/account_provider.dart';
import 'package:free_life/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Contas')),
      body: Consumer<AccountProvider>(
        builder: (context, provider, _) {
          // loading
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // erro
          if (provider.state == AccountState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage ?? 'Erro ao carregar contas.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchAccounts(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // lista vazia
          if (provider.accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: AppColors.primary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  const Text('Nenhuma conta cadastrada.'),
                ],
              ),
            );
          }

          // lista de contas
          return Column(
            children: [
              _TotalBalanceCard(total: provider.totalBalance),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.fetchAccounts,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.accounts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final account = provider.accounts[index];
                      return _AccountCard(
                        account: account,
                        onDelete: () =>
                            _confirmDelete(context, provider, account),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navegar para criar conta
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AccountProvider provider,
    Account account,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir conta'),
        content: Text('Deseja excluir a conta "${account.accountableType}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      final success = await provider.deleteAccount(account.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Conta excluída!'
                : provider.errorMessage ?? 'Erro ao excluir.',
          ),
        ),
      );
    }
  }
}

// --- Widgets privados da página ---

class _TotalBalanceCard extends StatelessWidget {
  final double total;

  const _TotalBalanceCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saldo total',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'R\$ ${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback onDelete;

  const _AccountCard({required this.account, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.account_balance_outlined, color: AppColors.primary),
        ),
        title: Text(
          account.accountableType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Rentabilidade: ${account.profitability}%'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              account.formattedAmount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: account.amount >= 0 ? AppColors.primary : Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
