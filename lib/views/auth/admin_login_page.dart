import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../l10n/generated/app_localizations.dart';
import 'otp_verification_page.dart';

class AdminLoginPage extends ConsumerStatefulWidget {
  const AdminLoginPage({super.key});

  @override
  ConsumerState<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends ConsumerState<AdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminAuthProvider);

    ref.listen(adminAuthProvider, (prev, next) {
      if (next.isAwaitingOtp && !(prev?.isAwaitingOtp ?? false)) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OtpVerificationPage()),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/app_logo.png', width: 200),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context).appTitle,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context).signInSubtitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],

                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        labelStyle: Theme.of(context).textTheme.titleLarge,
                        errorStyle: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        labelText: AppLocalizations.of(context).email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context).enterEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      style: Theme.of(context).textTheme.titleLarge,

                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.titleLarge,
                        errorStyle: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        labelText: AppLocalizations.of(context).password,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).enterPassword;
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 8),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,color: Colors.red
                            )
                          ),
                          child: Row(
                            spacing: 15,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error,color: Colors.red),
                              Expanded(
                                child: Text(
                                  state.errorMessage ??
                                      AppLocalizations.of(context).loginFailed,
                                  
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (state.isOffline)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              size: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context).offline,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      onPressed: state.isLoading ? null : _submit,

                      label: state.isLoading
                          ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context).signIn,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                    ),

                    SizedBox(height: 20),

                    if (state.hasError)
                      TextButton(
                        onPressed: () {
                          ref.read(adminAuthProvider.notifier).clearError();
                        },
                        child: Text(AppLocalizations.of(context).retry),
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ref
        .read(adminAuthProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);
  }
}
