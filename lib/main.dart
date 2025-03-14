import 'package:flutter/material.dart';

void main() {
  runApp(DonationApp());
}

class DonationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sedekah App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _selectedAmount = 10.0;
  final List<double> _donationAmounts = [5.0, 10.0, 25.0, 50.0, 100.0];
  final TextEditingController _customAmountController = TextEditingController();
  bool _isCustomAmount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iSedekah'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Center(
                child: Image.network(
                  'https://img.freepik.com/premium-vector/ramadan-pay-zakat-share-with-other-illustration-concept-muslim-giving-zakat-when-ramadan_278713-50.jpg?w=740', // Replace with your image
                  height: 200,
                  //errorBuilder: (context, error, stackTrace) => Container(
                  //height: 200,
                  //color: Colors.red.shade100,
                  //child: Center(),
                  //),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bersedekahlah',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Sedekah itu tidaklah mengurangkan harta (H.R. Muslim).',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 30),

              // Donation amount selection
              Text(
                'Nyatakan Jumlah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _donationAmounts.map((amount) {
                  return ChoiceChip(
                    label: Text('\RM${amount.toStringAsFixed(0)}'),
                    selected: !_isCustomAmount && _selectedAmount == amount,
                    onSelected: (selected) {
                      setState(() {
                        _selectedAmount = amount;
                        _isCustomAmount = false;
                      });
                    },
                  );
                }).toList()
                  ..add(
                    ChoiceChip(
                      label: Text('Jumlah khas'),
                      selected: _isCustomAmount,
                      onSelected: (selected) {
                        setState(() {
                          _isCustomAmount = selected;
                          if (selected) {
                            _customAmountController.text =
                                _selectedAmount.toString();
                          }
                        });
                      },
                    ),
                  ),
              ),
              SizedBox(height: 15),
              if (_isCustomAmount)
                TextField(
                  controller: _customAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Nyatakan Jumlah Khusus',
                    prefixText: '\RM',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    try {
                      setState(() {
                        _selectedAmount = double.parse(value);
                      });
                    } catch (e) {
                      // Handle parsing error
                    }
                  },
                ),
              SizedBox(height: 30),

              // Donation purpose
              Text(
                'Pilih di mana anda mahu infaq',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              CauseCard(
                title: 'Pusat Anak Yatim',
                description:
                    'Membantu kebajikan, pendidikan dan pembangunan kendiri anak anak yatim',
                iconData: Icons.child_care,
              ),
              SizedBox(height: 10),
              CauseCard(
                title: 'Masjid',
                description: 'Membantu mengimarahkan program program masjid',
                iconData: Icons.mosque,
              ),
              SizedBox(height: 10),
              CauseCard(
                title: 'Golongan asnaf',
                description:
                    'Membantu golongan yang memerlukan dan ibu tunggal',
                iconData: Icons.people,
              ),
              SizedBox(height: 30),

              // Donation button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          amount: _isCustomAmount
                              ? double.tryParse(_customAmountController.text) ??
                                  _selectedAmount
                              : _selectedAmount,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Sedekah Sekarang',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CauseCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData iconData;

  const CauseCard({
    Key? key,
    required this.title,
    required this.description,
    required this.iconData,
  }) : super(key: key);

  @override
  _CauseCardState createState() => _CauseCardState();
}

class _CauseCardState extends State<CauseCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _isSelected ? Colors.blue : Colors.grey.shade300,
          width: _isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                widget.iconData,
                size: 40,
                color: Colors.blue,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: _isSelected,
                onChanged: (value) {
                  setState(() {
                    _isSelected = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final double amount;

  const CheckoutPage({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: _isProcessing ? _buildProcessingView() : _buildCheckoutForm(),
    );
  }

  Widget _buildCheckoutForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rumusan Sedekah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumlah yang disedekah:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '\RM${widget.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Maklumat Peribadi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Penuh',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sila isi nama penuh anda';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mel',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sila isi emel anda';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Sila nyatakan emel yang sah';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            Text(
              'Maklumat Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombor Kad',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sila isi nombor kad anda';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Tarikh Luput (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _processPayment();
                  }
                },
                child: Text(
                  'Sedekah',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Sedekah anda sedang diproses...',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(amount: widget.amount),
        ),
      );
    });
  }
}

class SuccessPage extends StatelessWidget {
  final double amount;

  const SuccessPage({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                SizedBox(height: 30),
                Text(
                  'Thank You!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Sedekah anda berjumlah \RM${amount.toStringAsFixed(2)} telahpun berjaya diproses.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Anda akan mendapatkan email pengesahan dalam masa terdekat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Kembali ke laman utama',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DonationHistoryPage()),
                    );
                  },
                  child: Text(
                    'Lihat sejarah sedekah',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DonationHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Demo data for donation history
    final List<Map<String, dynamic>> donations = [
      {
        'tarikh': '2025-03-14',
        'jumlah': 25.00,
        'pilihan sedekah': 'Pusat Anak Yatim',
      },
      {
        'tarikh': '2025-02-28',
        'jumlah': 10.00,
        'pilihan sedekah': 'Masjid',
      },
      {
        'tarikh': '2025-01-15',
        'jumlah': 50.00,
        'pilihan sedekah': 'Golongan asnaf',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Sejarah Sedekah'),
      ),
      body: donations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tiada sejarah sedekah lagi',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        _getCauseIcon(donation['pilihan sedekah']),
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      'Telah disedekah \RM${donation['amount'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${donation['cause']} - ${donation['date']}',
                    ),
                    trailing: Icon(Icons.receipt),
                    onTap: () {
                      // Show receipt details
                      _showReceiptDetails(context, donation);
                    },
                  ),
                );
              },
            ),
    );
  }

  IconData _getCauseIcon(String cause) {
    switch (cause) {
      case 'Pusat Anak Yatim':
        return Icons.school;
      case 'Masjid':
        return Icons.local_hospital;
      case 'Golongan asnaf':
        return Icons.eco;
      default:
        return Icons.volunteer_activism;
    }
  }

  void _showReceiptDetails(
      BuildContext context, Map<String, dynamic> donation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resit Sedekah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReceiptRow('Tarikh:', donation['tarikh']),
            SizedBox(height: 8),
            _buildReceiptRow(
                'Jumlah:', '\RM${donation['amount'].toStringAsFixed(2)}'),
            SizedBox(height: 8),
            _buildReceiptRow('Pilihan sedekah:', donation['cause']),
            SizedBox(height: 8),
            _buildReceiptRow('Reference:',
                'DON-${donation['date']}-${(donation['amount'] * 100).toInt()}'),
            SizedBox(height: 16),
            Text(
              'Terima Kasih di atas sedekah anda!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // In a real app, this would generate and share a PDF receipt
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Resit telah dikongsi!')),
              );
              Navigator.pop(context);
            },
            icon: Icon(Icons.share),
            label: Text('Kongsi'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }
}
