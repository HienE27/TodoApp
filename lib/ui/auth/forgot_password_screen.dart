import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  var _autoValidateMode = AutovalidateMode.disabled;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Show error message if exists
            if (authProvider.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authProvider.errorMessage!),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'Đóng',
                      textColor: Colors.white,
                      onPressed: () {
                        authProvider.clearError();
                      },
                    ),
                  ),
                );
              });
            }

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPageTitle(),
                    const SizedBox(height: 20),
                    _buildDescription(),
                    const SizedBox(height: 40),
                    if (!_emailSent) ...[
                      _buildForm(authProvider),
                    ] else ...[
                      _buildSuccessMessage(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Text(
        "Quên mật khẩu",
        style: TextStyle(
          color: Colors.white.withOpacity(0.87),
          fontFamily: "Lato",
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      _emailSent
          ? "Chúng tôi đã gửi hướng dẫn đặt lại mật khẩu đến email của bạn."
          : "Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn hướng dẫn để đặt lại mật khẩu.",
      style: TextStyle(
        color: Colors.white.withOpacity(0.67),
        fontFamily: "Lato",
        fontSize: 16,
        height: 1.5,
      ),
    );
  }

  Widget _buildForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailField(),
          const SizedBox(height: 40),
          _buildResetButton(authProvider),
          const SizedBox(height: 24),
          _buildBackToLoginButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontFamily: "Lato",
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Nhập địa chỉ Email",
            hintStyle: const TextStyle(
              color: Color(0xFF535353),
              fontFamily: "Lato",
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            fillColor: const Color(0xFF1D1D1D),
            filled: true,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Email là bắt buộc";
            }
            final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value);
            if (!emailValid) {
              return "Email không hợp lệ!";
            }
            return null;
          },
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Lato",
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton(AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : () => _onHandleResetPassword(authProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8875FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          disabledBackgroundColor: const Color(0xFF8687E7).withOpacity(0.5),
        ),
        child: authProvider.isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          "Gửi hướng dẫn",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Lato",
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          "Quay lại đăng nhập",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Lato",
            color: Colors.white.withOpacity(0.67),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1D1D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF4CAF50),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF4CAF50),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                "Email đã được gửi!",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.87),
                  fontFamily: "Lato",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Vui lòng kiểm tra hộp thư của bạn (bao gồm cả thư mục spam) và làm theo hướng dẫn để đặt lại mật khẩu.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.67),
                  fontFamily: "Lato",
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8875FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "Quay lại đăng nhập",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Lato",
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: Text(
            "Gửi lại email",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Lato",
              color: Colors.white.withOpacity(0.67),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _onHandleResetPassword(AuthProvider authProvider) async {
    if (_autoValidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      final success = await authProvider.resetPassword(
        email: _emailController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _emailSent = true;
        });
      }
    }
  }
}