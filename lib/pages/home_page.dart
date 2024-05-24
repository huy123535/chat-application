import 'package:flutter/material.dart';
import 'package:untitled2/components/my_drawer.dart';
import 'package:untitled2/pages/search_page.dart';
import '../services/auth/auth_service.dart';
import '../components/widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void logout() {
    // get auth database
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: () {
            nextScreen(context, const SearchPage());
          },
          icon: const Icon(Icons.search)),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}
