import 'package:flutter/material.dart';
import '../activity_logger.dart';

class StoreDashboardPurchaseOrderScreen extends StatefulWidget {
  const StoreDashboardPurchaseOrderScreen({super.key});

  @override
  State<StoreDashboardPurchaseOrderScreen> createState() =>
      _StoreDashboardPurchaseOrderScreenState();
}

class _StoreDashboardPurchaseOrderScreenState
    extends State<StoreDashboardPurchaseOrderScreen> {

  final TextEditingController storeController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  void createPO() {
    if (storeController.text.isEmpty || qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ⭐ LOG PURCHASE ORDER CREATION
    ActivityLogger.addPurchaseOrder(storeController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PO Created for ${storeController.text}"),
        backgroundColor: Colors.green,
      ),
    );

    storeController.clear();
    qtyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Purchase Order",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Create Purchase Order",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // STORE NAME INPUT
            TextField(
              controller: storeController,
              decoration: InputDecoration(
                labelText: "Store Name",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // QUANTITY INPUT
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createPO,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "CREATE PO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "Purchase Order Feature Coming Soon",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
