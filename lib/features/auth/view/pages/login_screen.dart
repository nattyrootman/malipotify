import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/utilities/themes/app_colors.dart';
import 'package:myapp/core/loaders/loader.dart';
import 'package:myapp/core/utilities/snackbar.dart';
import 'package:myapp/features/auth/view/pages/signup_screen.dart';
import 'package:myapp/core/widegets/button.dart';
import 'package:myapp/core/widegets/text_fields.dart';
import 'package:myapp/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:myapp/features/home/view/pages/home_page.dart';

final isVisibleProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .loginUser(
            email: emailController.text,
            password: passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isloading =
        ref.watch(authViewModelProvider.select((val) => val?.isLoading)) ==
        true;
    final isVisible = ref.watch(isVisibleProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      next?.when(
        data: (data) {
          ShowSnackBar(context, 'Connexion réussie');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        },

        error: (error, st) {
          print("error: ${error.toString()}");
          ShowSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: isloading
          ? Loader()
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      icon: Icon(Icons.add_to_home_screen),
                    ),
                    Image.asset("assets/potify.png", height: 150),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 25),

                          TextFields(
                            textHint: "Email",
                            controller: emailController,
                          ),
                          TextFields(
                            isTextOsbcure: isVisible,
                            textHint: "Password",
                            controller: passwordController,
                            suffix: IconButton(
                              onPressed: () {
                                ref.read(isVisibleProvider.notifier).state =
                                    !isVisible;
                              },
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          MyButton(
                            width: MediaQuery.of(context).size.width,
                            height: 40,

                            textButton: 'Login',
                            gradient: AppColors.grad1,
                            onTap: () {
                              _submitForm();
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Non Inscrit?",
                                style: TextStyle(fontSize: 12),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
