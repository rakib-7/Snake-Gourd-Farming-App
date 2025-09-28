import 'package:flutter/material.dart';
import 'package:snake_gourd/screens/community_forum_page.dart';
import 'package:snake_gourd/screens/cultivation_page.dart';
import 'package:snake_gourd/screens/harvest_page.dart';
import 'package:snake_gourd/screens/pest_control_page.dart';
import 'package:snake_gourd/screens/pest_disease_page.dart';
import 'package:snake_gourd/screens/varieties_page.dart';
import 'package:snake_gourd/screens/weather_page.dart';
import '../data/app_data.dart';
import '../widgets/menu_button.dart';
import 'detail_page.dart';
import 'farmer_registration_page.dart';
import 'chashi_bot_page.dart';
import 'govt_scheme_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('চিচিঙ্গা সহায়িকা'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_snake_gourd.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.1), // ব্যাকগ্রাউন্ডকে হালকা ডার্ক করার জন্য
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.green.shade100);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0, // বাটনগুলোকে আরও বর্গাকার করার জন্য
                ),
                itemCount: AppData.menuItems.length,
                itemBuilder: (context, index) {
                  final item = AppData.menuItems[index];
                  return MenuButton(
                    item: item,
                    onTap: () {
                      Widget destinationPage;
                      switch (item.title) {
                        case 'বীজ ও জাত':
                          destinationPage = const VarietiesPage();
                          break;
                        case 'চাষাবাদ পদ্ধতি':
                          destinationPage = const CultivationPage();
                          break;
                        case 'আবহাওয়া ও মাটি':
                          destinationPage = const WeatherPage();
                          break;
                        case 'পোকামাকড় ও দমন':
                          destinationPage = const PestControlPage();
                          break;
                        case 'রোগবালাই ও প্রতিকার':
                          destinationPage = const PestDiseasePage();
                          break;
                        case 'ফসল সংগ্রহ':
                          destinationPage = const HarvestPage();
                          break;
                        case 'সরকারি প্রকল্পসমূহ':
                          destinationPage = const GovtSchemePage();
                          break;
                        case 'চাষি নিবন্ধন':
                          destinationPage = const FarmerRegistrationPage();
                          break;
                        case 'কৃষক ফোরাম':
                          destinationPage = const CommunityForumPage();
                          break;
                        case 'চাষি বট':
                          destinationPage = const ChashiBotPage();
                          break;
                        default:
                          destinationPage = DetailPage(item: item);
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => destinationPage),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

