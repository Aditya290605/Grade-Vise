import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3441),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF2C3441),
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title: const Text(
      //     'My Profile',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
      //     Container(
      //       margin: const EdgeInsets.only(right: 16),
      //       child: TextButton(
      //         onPressed: () {
      //           // Done button functionality would go here
      //         },
      //         style: TextButton.styleFrom(
      //           backgroundColor: Colors.white,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      //         ),
      //         child: const Text(
      //           'DONE',
      //           style: TextStyle(
      //             color: Colors.black,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              Container(
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A4456),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 60,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Akshay Syal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Class XI-B  |  Roll no: 04',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white70,
                              size: 30,
                            ),
                            onPressed: () {
                              // Camera functionality would go here
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Form fields
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            label: 'Your Email',
                            value: 'xxx@gmail.com',
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 24),
                          
                          _buildFormField(
                            label: 'Phone Number',
                            value: '+93123135',
                            icon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: 24),
                          
                          _buildFormField(
                            label: 'Class',
                            value: 'www.gfx.com',
                            icon: null,
                          ),
                          const SizedBox(height: 24),
                          
                          _buildFormField(
                            label: 'Birth Date',
                            value: 'xxx@gmail.com',
                            icon: Icons.lock_outlined,
                            hasEyeIcon: true,
                          ),
                          const SizedBox(height: 32),
                          
                          // Edit Profile Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Edit profile functionality would go here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C3441),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Logout functionality would go here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Bottom indicator
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String value,
    IconData? icon,
    bool hasEyeIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: Colors.grey,
                  size: 24,
                ),
              if (icon != null) const SizedBox(width: 16),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ),
              if (hasEyeIcon)
                const Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
            ],
          ),
        ),
      ],
    );
  }
}