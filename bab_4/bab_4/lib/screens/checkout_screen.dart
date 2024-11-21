import 'package:flutter/material.dart';
import 'package:bab_4/widget/chart_item.dart';
import 'package:bab_4/helpers/format_helper.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Map<String, dynamic>> _product = [
    {
      "image": "assets/images/foto_2.jpg",
      "name": "Watch",
      "brand": "Rolex",
      "price": 10000,
      "count": 1
    },
    {
      "image": "assets/images/foto_3.jpg",
      "name": "Hoodie",
      "brand": "Puma",
      "price": 20000,
      "count": 1
    },
  ];

  double get subtotal =>
      _product.fold(0, (sum, item) => sum + (item['price'] * item['count']));

  int get discount => 12000;

  double get total => subtotal - discount;

  // Fungsi untuk mengupdate jumlah produk
  void updateProductCount(int index, int change) {
    setState(() {
      _product[index]['count'] += change;
      if (_product[index]['count'] < 1)
        _product[index]['count'] = 1; // Minimum 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Cart')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _product.length,
                itemBuilder: (context, index) {
                  return ChartItem(
                    imagePath: _product[index]['image'],
                    name: _product[index]['name'],
                    brand: _product[index]['brand'],
                    price: _product[index]['price'],
                    count: _product[index]['count'],
                    onMin: () => updateProductCount(index, -1), // Tombol -
                    onPlus: () => updateProductCount(index, 1), // Tombol +
                  );
                },
              ),
            ),
            // Divider(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromARGB(40, 158, 158, 158)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    OrderSummaryRow(
                        label: 'Items', value: '${_product.length}'),
                    OrderSummaryRow(
                        label: 'Subtotal', value: formatToRupiah(subtotal)),
                    OrderSummaryRow(
                        label: 'Discount', value: formatToRupiah(discount)),
                    Divider(),
                    OrderSummaryRow(
                        label: 'Total',
                        value: formatToRupiah(total),
                        isBold: true),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Center(
                        child: Text(
                          'Check Out',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const OrderSummaryRow({
    Key? key,
    required this.label,
    required this.value,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
