import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gss_manager_app/features/auth/persentation/screens/login_screen.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 64,
          ),
          const Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            size: 64,
            color: Colors.orange,
          ),
          const Text('Unauthorized', style: TextStyle(fontSize: 24)),
          const Text('You are not authorized to do this action'),
          const Text('You can try to login again'),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text('Login'),
          )
        ],
      ),
    );
  }
}
