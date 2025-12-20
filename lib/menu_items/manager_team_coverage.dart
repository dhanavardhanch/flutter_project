import 'package:flutter/material.dart';

class ManagerTeamCoverageScreen extends StatelessWidget {
  const ManagerTeamCoverageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Team Coverage",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.blue),
            ),
            child: const Text(
              "MTD",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER INFO ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "REPORTING TO ANDHRA PRADESH_SR...",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  "ALL FIELD USER",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ---------- CARDS ----------
            _coverageCard(
              position: "L2POSITION",
              name: "Andhra Pradesh_SR_Exec01",
              subtitle: "(P Durga Prasad)",
              location: "VIJAYAWADA",
              distributor: "7",
              beats: "63",
              outlets: "2,399",
              planned: "0",
              upc: "353",
              utc: "1,080",
            ),

            _coverageCard(
              position: "L1POSITION",
              name: "Andhra Pradesh_SR/S001",
              subtitle: "(Laxmi Narayan Rao)",
              location: "VISAKHAPATNAM",
              distributor: "2",
              beats: "12",
              outlets: "448",
              planned: "0",
              upc: "139",
              utc: "373",
            ),

            _coverageCard(
              position: "L1POSITION",
              name: "Andhra Pradesh_SR/S002",
              subtitle: "(Vidya Sagar Gemm...)",
              location: "VIJAYAWADA",
              distributor: "1",
              beats: "12",
              outlets: "317",
              planned: "0",
              upc: "57",
              utc: "266",
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // 🟦 COVERAGE CARD
  // ======================================================
  Widget _coverageCard({
    required String position,
    required String name,
    required String subtitle,
    required String location,
    required String distributor,
    required String beats,
    required String outlets,
    required String planned,
    required String upc,
    required String utc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- HEADER ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                position,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                location,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style:
                      const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _iconCircle(Icons.chat),
                  const SizedBox(width: 6),
                  _iconCircle(Icons.call),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---------- METRICS ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric("Distributor", distributor),
              _metric("Beats", beats),
              _metric("Outlets", outlets),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric("Outlets Planned", planned),
              _metric("UPC", upc),
              _metric("UTC", utc),
            ],
          ),
        ],
      ),
    );
  }

  // ======================================================
  // COMPONENTS
  // ======================================================
  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _iconCircle(IconData icon) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.blue.shade50,
      child: Icon(icon, size: 16, color: Colors.blue),
    );
  }
}
