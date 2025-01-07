import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../constants/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  final UserModel user;
  
  const DashboardScreen({
    super.key,
    required this.user,
  });

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: Colors.white,
        title: Text(
          'Welcome ${user.userName}',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Information',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard('Name', user.userName),
              const SizedBox(height: 16),
              _buildInfoCard('Parent Name', user.parentName),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard('Class', user.userStd),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard('Type', user.userType),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard('Mobile', user.userMobile),
              const SizedBox(height: 16),
              _buildInfoCard('Address', user.userAddress),
              if (user.userBg.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildInfoCard('Blood Group', user.userBg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
