import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoapp/features/core/routes/app_routes.dart';

import '../../../core/common/styles.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      context.read<AuthBloc>().add(
        EmailSignUpEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        ),
      );
    } else if (!_acceptTerms) {
      Fluttertoast.showToast(
        msg: "Please accept the terms and conditions",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.onError,
            );
          } else if (state is Authenticated) {
            // Navigate to home page or dashboard
            Navigator.pushReplacementNamed(context, AppRoutes.main);
            Fluttertoast.showToast(
              msg: "Registration successful!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColors.primaryLight,
              textColor: AppColors.white,
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Create account text
                    Text(
                      'Create Account',
                      style: AppTextStyle.headline1(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign up to get started',
                      style: AppTextStyle.subtitle1(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    // Name field
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Terms and conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: AppTextStyle.bodyText2(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: AppTextStyle.bodyText2(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  // You can add a gesture detector here for terms
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: AppTextStyle.bodyText2(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTextStyle.bodyText2(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  // You can add a gesture detector here for privacy policy
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Sign up button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is! AuthLoading ? _signUp : null,
                          child:
                              state is AuthLoading
                                  ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: CircularProgressIndicator(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                  : Text(
                                    'Sign Up',
                                    style: AppTextStyle.button(),
                                  ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Already have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: AppTextStyle.bodyText1(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Sign In',
                            style: AppTextStyle.subtitle2(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
