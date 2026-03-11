import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress(order.status);
    final trackingId = 'APK-${order.id.substring(0, order.id.length.clamp(0, 12)).toUpperCase()}';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Track Order'),
            Text(
              '#${order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.statusText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.backgroundColor,
                      valueColor: AlwaysStoppedAnimation(_getStatusColor(order.status)),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Status dots row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusDot('Placed', OrderStatus.pending),
                      _buildStatusLine(OrderStatus.confirmed),
                      _buildStatusDot('Confirmed', OrderStatus.confirmed),
                      _buildStatusLine(OrderStatus.processing),
                      _buildStatusDot('Making', OrderStatus.processing),
                      _buildStatusLine(OrderStatus.shipped),
                      _buildStatusDot('Shipped', OrderStatus.shipped),
                      _buildStatusLine(OrderStatus.delivered),
                      _buildStatusDot('Delivered', OrderStatus.delivered),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tracking number card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.qr_code, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tracking Number',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trackingId,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_outlined, color: AppTheme.primaryColor),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: trackingId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tracking number copied!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: order.productImage != null
                            ? Image.network(
                                order.productImage!,
                                width: 60, height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _imagePlaceholder(),
                              )
                            : _imagePlaceholder(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.productName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Qty: ${order.quantity}  ·  ₹${order.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(Icons.person_outline, order.customerName),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.location_on_outlined, order.customerAddress),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.access_time, _formatDate(order.createdAt)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Timeline
            const Text(
              'Timeline',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDot(String label, OrderStatus status) {
    final reached = _statusIndex(order.status) >= _statusIndex(status);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: reached ? AppTheme.primaryColor : AppTheme.backgroundColor,
            border: Border.all(
              color: reached ? AppTheme.primaryColor : AppTheme.textLight,
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: reached ? AppTheme.primaryColor : AppTheme.textLight,
            fontWeight: reached ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLine(OrderStatus status) {
    final reached = _statusIndex(order.status) >= _statusIndex(status);
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        color: reached ? AppTheme.primaryColor : AppTheme.backgroundColor,
      ),
    );
  }

  Widget _buildTimeline() {
    final events = _getTimelineEvents();
    return Column(
      children: events.asMap().entries.map((entry) {
        final i = entry.key;
        final event = entry.value;
        final isLast = i == events.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: event['done'] == true ? AppTheme.primaryColor : AppTheme.backgroundColor,
                    border: Border.all(
                      color: event['done'] == true ? AppTheme.primaryColor : AppTheme.textLight,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: event['done'] == true
                        ? AppTheme.primaryColor.withValues(alpha: 0.3)
                        : AppTheme.backgroundColor,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: event['done'] == true ? AppTheme.textPrimary : AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event['subtitle'] as String,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getTimelineEvents() {
    final idx = _statusIndex(order.status);
    final created = order.createdAt;
    return [
      {
        'title': 'Order Placed',
        'subtitle': _formatDate(created),
        'done': idx >= 0,
      },
      {
        'title': 'Order Confirmed',
        'subtitle': idx >= 1 ? 'Artisan confirmed your order' : 'Pending artisan confirmation',
        'done': idx >= 1,
      },
      {
        'title': 'Being Made',
        'subtitle': idx >= 2 ? 'Artisan is crafting your item' : 'Not started yet',
        'done': idx >= 2,
      },
      {
        'title': 'Shipped',
        'subtitle': idx >= 3 ? 'Your order is on its way' : 'Awaiting dispatch',
        'done': idx >= 3,
      },
      {
        'title': 'Delivered',
        'subtitle': order.deliveredAt != null
            ? _formatDate(order.deliveredAt!)
            : idx >= 4
                ? 'Delivered successfully'
                : 'Expected in 5–7 business days',
        'done': idx >= 4,
      },
    ];
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 60, height: 60,
      color: AppTheme.backgroundColor,
      child: const Icon(Icons.image, color: AppTheme.textLight),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          ),
        ),
      ],
    );
  }

  double _getProgress(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:    return 0.1;
      case OrderStatus.confirmed:  return 0.3;
      case OrderStatus.processing: return 0.55;
      case OrderStatus.shipped:    return 0.8;
      case OrderStatus.delivered:  return 1.0;
      case OrderStatus.cancelled:  return 0.0;
    }
  }

  int _statusIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:    return 0;
      case OrderStatus.confirmed:  return 1;
      case OrderStatus.processing: return 2;
      case OrderStatus.shipped:    return 3;
      case OrderStatus.delivered:  return 4;
      case OrderStatus.cancelled:  return -1;
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:    return const Color(0xFFF59E0B);
      case OrderStatus.confirmed:  return const Color(0xFF3B82F6);
      case OrderStatus.processing: return const Color(0xFF8B5CF6);
      case OrderStatus.shipped:    return const Color(0xFF06B6D4);
      case OrderStatus.delivered:  return AppTheme.successColor;
      case OrderStatus.cancelled:  return AppTheme.errorColor;
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}';
  }
}
