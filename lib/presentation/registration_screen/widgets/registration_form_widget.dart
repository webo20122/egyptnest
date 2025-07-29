import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool agreeToTerms;
  final bool subscribeToNewsletter;
  final bool isLoading;
  final String selectedUserType;
  final VoidCallback onObscurePasswordToggle;
  final VoidCallback onObscureConfirmPasswordToggle;
  final ValueChanged<bool?> onAgreeToTermsChanged;
  final ValueChanged<bool?> onSubscribeChanged;
  final VoidCallback onRegister;

  const RegistrationFormWidget({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.agreeToTerms,
    required this.subscribeToNewsletter,
    required this.isLoading,
    required this.selectedUserType,
    required this.onObscurePasswordToggle,
    required this.onObscureConfirmPasswordToggle,
    required this.onAgreeToTermsChanged,
    required this.onSubscribeChanged,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name Row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        
        SizedBox(height: 3.h),
        
        // Email Field
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            prefixIcon: CustomIconWidget(
              iconName: 'email',
              color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        
        SizedBox(height: 3.h),
        
        // Phone Field
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        
        SizedBox(height: 3.h),
        
        // Password Field
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            suffixIcon: IconButton(
              onPressed: onObscurePasswordToggle,
              icon: CustomIconWidget(
                iconName: obscurePassword ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return 'Password must contain uppercase, lowercase, and number';
            }
            return null;
          },
        ),
        
        SizedBox(height: 3.h),
        
        // Confirm Password Field
        TextFormField(
          controller: confirmPasswordController,
          obscureText: obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            suffixIcon: IconButton(
              onPressed: onObscureConfirmPasswordToggle,
              icon: CustomIconWidget(
                iconName: obscureConfirmPassword ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        
        SizedBox(height: 3.h),
        
        // Terms and Conditions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: agreeToTerms,
              onChanged: onAgreeToTermsChanged,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // Newsletter Subscription
        Row(
          children: [
            Checkbox(
              value: subscribeToNewsletter,
              onChanged: onSubscribeChanged,
            ),
            Expanded(
              child: Text(
                'Subscribe to our newsletter for updates and promotions',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 4.h),
        
        // Register Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onRegister,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    selectedUserType == 'host' ? 'Create Host Account' : 'Create Account',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}