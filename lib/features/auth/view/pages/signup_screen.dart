import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/user_notifier.dart';
import 'package:myapp/core/utilities/themes/app_colors.dart';
import 'package:myapp/core/loaders/loader.dart';
import 'package:myapp/core/utilities/snackbar.dart';
import 'package:myapp/features/auth/view/pages/login_screen.dart';
import 'package:myapp/core/widegets/button.dart';
import 'package:myapp/core/widegets/text_fields.dart';
import 'package:myapp/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:myapp/features/home/view/pages/home_page.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .signupUser(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userNotifierProvider.notifier);
    final isloading =
        ref.watch(authViewModelProvider.select((val) => val?.isLoading)) ==
      true;
    final isVisible = ref.watch(isVisibleProvider);
    ref.listen(authViewModelProvider, (prev, next) {
      next?.when(
        data: (data) async {
          ShowSnackBar(context, 'Inscription réussie');
         
          

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        },
        error: (error, st) {
          ShowSnackBar(context, error.toString());
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      );
    });

    return Scaffold(
      body: isloading
          ? Loader()
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset("assets/potify.png", height: 150),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 25),
                              TextFields(
                                textHint: "Nom",
                                controller: nameController,
                              ),
                              TextFields(
                                textHint: "Adresse Email",
                                controller: emailController,
                              ),
                              TextFields(
                                isTextOsbcure: isVisible,
                                textHint: "Mot de passe",
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

                              SizedBox(height: 20),
                              MyButton(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                textButton: "S'inscrire",
                                gradient: AppColors.grad1,

                                onTap: () {
                                  _submitForm();
                                },
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Déjà membre?",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Connexion",
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
              ),
            ),
    );
  }
}
