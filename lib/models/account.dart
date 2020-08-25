class Account {
  final String id;
  final String status;
  final double equity;
  final double cash;

  Account({this.id, this.status, this.equity, this.cash});

  factory Account.fromMap(dynamic alpacaAccount) {
    return Account(
      id: alpacaAccount['id'],
      status: alpacaAccount['status'],
      cash: double.parse(alpacaAccount['cash']),
      equity: double.parse(alpacaAccount['equity']),
    );
  }
}
