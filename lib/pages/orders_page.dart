import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_client.dart';
import '../services/auth_scope.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final response = await ApiClient.instance.get('/orders');
    final data = response is Map ? response['data'] : null;

    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((order) => order.cast<String, dynamic>())
        .toList();
  }

  Future<void> _refresh() async {
    setState(() => _ordersFuture = _load());
    await _ordersFuture;
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Siparişlerim')),
      body: !auth.isAuthenticated
          ? const Center(child: Text('Siparişler için giriş yapın.'))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final orders = snapshot.data ?? const [];

                if (orders.isEmpty) {
                  return const Center(child: Text('Henüz siparişiniz yok.'));
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _OrderCard(order: orders[index]),
                  ),
                );
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = order['status']?.toString() ?? 'pending';
    final total = (order['total_cents'] as num?)?.toInt() ?? 0;
    final items = order['items'] is List ? order['items'] as List : const [];
    final placedAt = DateTime.tryParse(order['placed_at']?.toString() ?? '');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order['number']?.toString() ?? '',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  '\$${(total / 100).toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  _statusLabel(status),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (placedAt != null)
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(placedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
              ],
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                items
                    .map((item) {
                      final map = item as Map;
                      return '${map['quantity']}× ${map['product_name']}';
                    })
                    .join(', '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    return switch (status) {
      'pending' => 'Beklemede',
      'paid' => 'Ödendi',
      'processing' => 'Hazırlanıyor',
      'shipped' => 'Kargoda',
      'delivered' => 'Teslim edildi',
      'cancelled' => 'İptal edildi',
      'refunded' => 'İade edildi',
      _ => status,
    };
  }
}
