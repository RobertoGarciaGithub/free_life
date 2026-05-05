class Account {
  final String id;
  final String bankId;
  final String accountableType;
  final String accountableId;
  final int amountCents;
  final String amountCurrency;
  final double profitability;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    required this.id,
    required this.bankId,
    required this.accountableType,
    required this.accountableId,
    required this.amountCents,
    required this.amountCurrency,
    required this.profitability,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json['id'],
    bankId: json['bank_id'],
    accountableType: json['accountable_type'],
    accountableId: json['accountable_id'],
    amountCents: json['amount_cents'] ?? 0,
    amountCurrency: json['amount_currency'] ?? 'BRL',
    profitability: (json['profitability'] as num).toDouble(),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'bank_id': bankId,
    'accountable_type': accountableType,
    'accountable_id': accountableId,
    'amount_cents': amountCents,
    'amount_currency': amountCurrency,
    'profitability': profitability,
  };

  // Converte cents para reais (padrão do gem monetize do Rails)
  double get amount => amountCents / 100;

  String get formattedAmount =>
      'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}';
}
