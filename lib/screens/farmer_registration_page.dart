import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FarmerRegistrationPage extends StatefulWidget {
  const FarmerRegistrationPage({super.key});

  @override
  State<FarmerRegistrationPage> createState() => _FarmerRegistrationPageState();
}

class _FarmerRegistrationPageState extends State<FarmerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _supabase = Supabase.instance.client; // Supabase ক্লায়েন্ট

  Future<void> _registerFarmer() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _supabase.from('farmers').insert({
        'name': _nameController.text,
        'address': _addressController.text,
        'mobile': _mobileController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('নিবন্ধন সফল হয়েছে!')));
        _nameController.clear();
        _addressController.clear();
        _mobileController.clear();
        setState(() {}); // তালিকা রিফ্রেশ করার জন্য
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('একটি ত্রুটি ঘটেছে: $e')));
      }
    }
  }

  Future<List<dynamic>> _fetchFarmers() async {
    try {
      final data = await _supabase.from('farmers').select().order('created_at', ascending: false);
      return data;
    } catch (e) {
      throw Exception('ডেটা আনতে সমস্যা হয়েছে: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('চাষি নিবন্ধন')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('নতুন চাষি নিবন্ধন করুন', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'নাম', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'অনুগ্রহ করে নাম লিখুন' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'ঠিকানা', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'অনুগ্রহ করে ঠিকানা লিখুন' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(labelText: 'মোবাইল নম্বর', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'অনুগ্রহ করে মোবাইল নম্বর লিখুন' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registerFarmer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('নিবন্ধন করুন'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text('নিবন্ধিত কৃষকদের তালিকা', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FutureBuilder<List<dynamic>>(
              future: _fetchFarmers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('ত্রুটি: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('কোনো কৃষক নিবন্ধিত নেই'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final farmer = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(farmer['name'] ?? 'নাম নেই'),
                          subtitle: Text('ঠিকানা: ${farmer['address'] ?? 'N/A'}\nমোবাইল: ${farmer['mobile'] ?? 'N/A'}'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

