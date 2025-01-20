import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../constants/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel user;
  
  const DashboardScreen({
    super.key,
    required this.user,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;
  final List<TextEditingController> _controllers = [];
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _createController(String initialText) {
    final controller = TextEditingController(text: initialText);
    _controllers.add(controller);
    return controller;
  }

  final List<_SidebarItem> _sidebarItems = [
    const _SidebarItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      activeIcon: Icons.dashboard_rounded,
    ),
    const _SidebarItem(
      title: 'Assignments',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
    ),
    const _SidebarItem(
      title: 'Attendance',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
    ),
    const _SidebarItem(
      title: 'Grades',
      icon: Icons.grade_outlined,
      activeIcon: Icons.grade,
    ),
    const _SidebarItem(
      title: 'Schedule',
      icon: Icons.schedule_outlined,
      activeIcon: Icons.schedule,
    ),
    const _SidebarItem(
      title: 'Messages',
      icon: Icons.message_outlined,
      activeIcon: Icons.message,
    ),
    const _SidebarItem(
      title: 'Library',
      icon: Icons.library_books_outlined,
      activeIcon: Icons.library_books,
    ),
    const _SidebarItem(
      title: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
    ),
  ];

  Widget _buildSidebar() {
    return Container(
      width: _isSidebarExpanded ? 280 : 80,
      color: const Color(0xFF2C3E50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSidebarExpanded = !_isSidebarExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isSidebarExpanded ? Icons.menu_open : Icons.menu,
                      color: Colors.white,
                    ),
                    if (_isSidebarExpanded) ...[
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          'Menu',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (_isSidebarExpanded) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showProfileEditDialog(),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 32, // Reduced from 40
                          backgroundColor: AppColors.primaryYellow,
                          child: Text(
                            widget.user.userName.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 24, // Reduced from 32
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.user.userName,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.user.userType,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _sidebarItems.length,
              itemBuilder: (context, index) {
                final item = _sidebarItems[index];
                final isSelected = _selectedIndex == index;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryYellow
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                          if (_isSidebarExpanded) ...[
                            const SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70),
            title: _isSidebarExpanded
                ? Text(
                    'Logout',
                    style: GoogleFonts.inter(color: Colors.white70),
                  )
                : null,
            onTap: () => _showLogoutConfirmationDialog(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showProfileEditDialog() async {
    final nameController = _createController(widget.user.userName);
    final parentNameController = _createController(widget.user.parentName);
    final mobileController = _createController(widget.user.userMobile);
    final addressController = _createController(widget.user.userAddress);
    final bgController = _createController(widget.user.userBg);
    final ageController = _createController(widget.user.userAge.toString());
    final genderController = _createController(widget.user.userGender);
    final currentPasswordController = _createController('');
    final newPasswordController = _createController('');
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    
    String? selectedClass = widget.user.userStd;
    String? selectedType = widget.user.userType;

    final List<String> classOptions = ['1st', '2nd', '3rd', '4th', '5th'];
    final List<String> typeOptions = ['Student', 'Teacher', 'Admin'];

    // Validate initial values
    if (!classOptions.contains(selectedClass)) {
      selectedClass = classOptions.first;
    }
    if (!typeOptions.contains(selectedType)) {
      selectedType = typeOptions.first;
    }

    Widget buildFieldWithDelete(TextEditingController controller, String label, {bool isNumber = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                controller.clear();
              },
            ),
          ],
        ),
      );
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildFieldWithDelete(nameController, 'Name'),
                          const SizedBox(height: 16),
                          buildFieldWithDelete(parentNameController, 'Parent Name'),
                          const SizedBox(height: 16),
                          buildFieldWithDelete(genderController, 'Gender'),
                          const SizedBox(height: 16),
                          buildFieldWithDelete(ageController, 'Age', isNumber: true),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: currentPasswordController,
                                  decoration: InputDecoration(
                                    labelText: 'Current Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscureCurrentPassword = !obscureCurrentPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: obscureCurrentPassword,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: newPasswordController,
                                  decoration: InputDecoration(
                                    labelText: 'New Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscureNewPassword = !obscureNewPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: obscureNewPassword,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedClass,
                                  decoration: const InputDecoration(labelText: 'Class'),
                                  items: classOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedClass = newValue;
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedClass = classOptions.first;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedType,
                                  decoration: const InputDecoration(labelText: 'Type'),
                                  items: typeOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedType = newValue;
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedType = typeOptions.first;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          buildFieldWithDelete(mobileController, 'Mobile'),
                          const SizedBox(height: 16),
                          buildFieldWithDelete(addressController, 'Address'),
                          const SizedBox(height: 16),
                          buildFieldWithDelete(bgController, 'Blood Group'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            if (selectedClass == null || selectedType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select class and type')),
                              );
                              return;
                            }

                            // Verify current password if trying to change password
                            if (newPasswordController.text.isNotEmpty) {
                              if (currentPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter current password to change password'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (currentPasswordController.text != widget.user.userPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Current password is incorrect'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                            }

                            final updateData = {
                              'parent_name': parentNameController.text.trim(),
                              'user_address': addressController.text.trim(),
                              'user_bg': bgController.text.trim(),
                              'user_mobile': mobileController.text.trim(),
                              'user_name': nameController.text.trim(),
                              'user_std': selectedClass,
                              'user_type': selectedType,
                              'user_gender': genderController.text.trim(),
                              'user_age': int.tryParse(ageController.text.trim()) ?? 0,
                            };

                            // Only update password if new password is provided and current password is verified
                            if (newPasswordController.text.isNotEmpty && currentPasswordController.text == widget.user.userPassword) {
                              updateData['user_password'] = newPasswordController.text.trim();
                            }

                            final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                .collection('User')
                                .where('user_id', isEqualTo: widget.user.userId)
                                .limit(1)
                                .get();

                            if (querySnapshot.docs.isEmpty) {
                              throw Exception('User document not found');
                            }

                            final docRef = querySnapshot.docs.first.reference;
                            await docRef.update(updateData);

                            if (!mounted) return;
                            Navigator.pop(context);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(
                                  user: UserModel(
                                    userId: widget.user.userId,
                                    userName: nameController.text.trim(),
                                    parentName: parentNameController.text.trim(),
                                    userAddress: addressController.text.trim(),
                                    userBg: bgController.text.trim(),
                                    userMobile: mobileController.text.trim(),
                                    userStd: selectedClass ?? '',
                                    userType: selectedType ?? '',
                                    userPassword: newPasswordController.text.isNotEmpty ? 
                                        newPasswordController.text.trim() : widget.user.userPassword,
                                    userAge: int.tryParse(ageController.text.trim()) ?? 0,
                                    userGender: genderController.text.trim(),
                                  ),
                                ),
                              ),
                            );
                          } catch (e) {
                            debugPrint('Error updating profile: $e');
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update profile: ${e.toString()}'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryYellow,
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showChangePasswordDialog() async {
    final currentPasswordController = _createController('');
    final newPasswordController = _createController('');
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Change Password',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureCurrentPassword = !obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                obscureText: obscureCurrentPassword,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureNewPassword = !obscureNewPassword;
                      });
                    },
                  ),
                ),
                obscureText: obscureNewPassword,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final currentPassword = currentPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();

                if (currentPassword.isEmpty || newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in both passwords'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (currentPassword != widget.user.userPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Current password is incorrect'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('User')
                      .where('user_id', isEqualTo: widget.user.userId)
                      .limit(1)
                      .get();

                  if (querySnapshot.docs.isEmpty) {
                    throw Exception('User document not found');
                  }

                  final docRef = querySnapshot.docs.first.reference;
                  await docRef.update({'user_password': newPassword});

                  if (!mounted) return;
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Refresh the page with updated user data
                  final updatedData = querySnapshot.docs.first.data() as Map<String, dynamic>;
                  updatedData['user_password'] = newPassword;
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                        user: UserModel.fromFirestore(updatedData),
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update password: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
              ),
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );

  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  size: 48,
                  color: AppColors.primaryYellow,
                ),
                const SizedBox(height: 16),
                Text(
                  'Confirm Logout',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to logout?',
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileField(String label, String value, Function(String) onUpdate, {bool canDelete = true}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          label == 'Password' ? '••••••••' : value,
          style: GoogleFonts.inter(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label == 'Password')
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primaryYellow),
                onPressed: () => _showChangePasswordDialog(),
              )
            else ...[
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primaryYellow),
                onPressed: () async {
                  final controller = _createController(value);
                  String? newValue = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Edit $label'),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(labelText: label),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, controller.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                  if (newValue != null && newValue.isNotEmpty) {
                    onUpdate(newValue);
                  }
                  controller.dispose();
                },
              ),
              if (canDelete)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Clear $label'),
                        content: const Text('Are you sure you want to clear this field?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      onUpdate('');
                    }
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _updateField(String field, String value) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('user_id', isEqualTo: widget.user.userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('User document not found');
      }

      final docRef = querySnapshot.docs.first.reference;
      await docRef.update({field: value});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the page with updated data
      final updatedData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      updatedData[field] = value;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            user: UserModel.fromFirestore(updatedData),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error updating field: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildProfileField(
            'Name',
            widget.user.userName,
            (value) => _updateField('user_name', value),
          ),
          _buildProfileField(
            'Parent Name',
            widget.user.parentName,
            (value) => _updateField('parent_name', value),
          ),
          _buildProfileField(
            'Mobile',
            widget.user.userMobile,
            (value) => _updateField('user_mobile', value),
          ),
          _buildProfileField(
            'Address',
            widget.user.userAddress,
            (value) => _updateField('user_address', value),
          ),
          _buildProfileField(
            'Blood Group',
            widget.user.userBg,
            (value) => _updateField('user_bg', value),
          ),
          _buildProfileField(
            'Class',
            widget.user.userStd,
            (value) => _updateField('user_std', value),
          ),
          _buildProfileField(
            'Type',
            widget.user.userType,
            (value) => _updateField('user_type', value),
          ),
          _buildProfileField(
            'Gender',
            widget.user.userGender,
            (value) => _updateField('user_gender', value),
          ),
          _buildProfileField(
            'Age',
            widget.user.userAge.toString(),
            (value) => _updateField('user_age', int.tryParse(value)?.toString() ?? '0'),
          ),
          _buildProfileField(
            'Email',
            widget.user.userId,
            (value) => _updateField('user_id', value),
            canDelete: false, // Don't allow deleting the email
          ),
          _buildProfileField(
            'Password',
            widget.user.userPassword,
            (value) => _updateField('user_password', value),
            canDelete: false, // Don't allow deleting the password
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildAssignments();
      case 2:
        return _buildAttendance();
      case 3:
        return _buildGrades();
      case 4:
        return _buildSchedule();
      case 5:
        return _buildMessages();
      case 6:
        return _buildLibrary();
      case 7:
        return _buildProfileContent();
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${widget.user.userName}!',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Attendance',
                  '85%',
                  Icons.calendar_today,
                  AppColors.primaryYellow,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatsCard(
                  'Assignments',
                  '12',
                  Icons.assignment,
                  AppColors.primaryOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatsCard(
                  'Average Grade',
                  'A',
                  Icons.grade,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildRecentActivities(),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Activities')
          .where('user_id', isEqualTo: widget.user.userId)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final activities = snapshot.data?.docs ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryYellow.withOpacity(0.1),
                      child: Icon(
                        _getActivityIcon(activity['type'] as String),
                        color: AppColors.primaryYellow,
                      ),
                    ),
                    title: Text(activity['title'] as String),
                    subtitle: Text(
                      _formatTimestamp(activity['timestamp'] as Timestamp),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAssignments() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Assignments')
          .where('class', isEqualTo: widget.user.userStd)
          .orderBy('due_date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final assignments = snapshot.data?.docs ?? [];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assignments',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement new assignment creation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Coming Soon: Create Assignment'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New Assignment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: assignments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.assignment_outlined,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No assignments yet',
                              style: GoogleFonts.inter(
                                color: AppColors.textLight,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: assignments.length,
                        itemBuilder: (context, index) {
                          final assignment = assignments[index].data()
                              as Map<String, dynamic>;
                          return Card(
                            elevation: 0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(assignment['title'] as String),
                              subtitle: Text(
                                'Due: ${_formatDate(assignment['due_date'] as Timestamp)}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  // TODO: Navigate to assignment details
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendance() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Attendance Coming Soon',
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrades() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.grade,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Grades Coming Soon',
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedule() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.schedule,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Schedule Coming Soon',
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.message,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Messages Coming Soon',
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLibrary() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.library_books,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Library Coming Soon',
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.settings,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Settings Coming Soon',
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'login':
        return Icons.login;
      case 'update':
        return Icons.edit;
      case 'assignment':
        return Icons.assignment;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    
    Widget mainContent = _buildContent();

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            _buildSidebar(),
            Expanded(child: mainContent),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: mainContent,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryYellow,
          unselectedItemColor: Colors.grey,
          items: _sidebarItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.title,
          )).toList(),
        ),
      );
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildAssignments();
      case 2:
        return _buildAttendance();
      case 3:
        return _buildGrades();
      case 4:
        return _buildSchedule();
      case 5:
        return _buildMessages();
      case 6:
        return _buildLibrary();
      case 7:
        return _buildSettings();
      default:
        return _buildDashboardContent();
    }
  }
}

class _SidebarItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const _SidebarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
  });
}
