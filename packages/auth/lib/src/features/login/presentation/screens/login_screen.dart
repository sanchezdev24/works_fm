import 'package:auth/src/features/login/presentation/bloc/login_bloc.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<core.ShadFormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final theme = core.ShadTheme.of(context);

    return core.BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if(state is LoginStateIsError) {
            core.ShadSonner.of(context).show(
              core.ShadToast.destructive(
                id: 'login_error',
                title: const Text('Error'),
                description: Text(state.errorMsg),
              ),
            );
          } else if(state is LoginStateIsSuccess) {

          }
        }, 
        builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xFFFAF8F5),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // ── Brand Header ──────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.diamond_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'MAISON',
                        style: theme.textTheme.h1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 6,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Luxury Fashion',
                        style: theme.textTheme.muted.copyWith(
                          letterSpacing: 2,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // ── Card ──────────────────────────────────────────────
                core.ShadCard(
                  padding: const EdgeInsets.all(24),
                  child: core.ShadForm(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenida de nuevo',
                          style: theme.textTheme.h3.copyWith(
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ingresa a tu cuenta para continuar',
                          style: theme.textTheme.muted,
                        ),

                        const SizedBox(height: 28),

                        // ── Email ──
                        core.ShadInputFormField(
                          id: 'email',
                          label: const Text('Correo electrónico'),
                          placeholder: const Text('hola@ecommerce.mx'),
                          keyboardType: TextInputType.emailAddress,
                          leading: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              core.LucideIcons.mail,
                              size: 16,
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingresa tu correo';
                            }
                            if (!value.contains('@')) {
                              return 'Correo inválido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ── Password ──
                        core.ShadInputFormField(
                          id: 'password',
                          label: const Text('Contraseña'),
                          placeholder: const Text('••••••••'),
                          obscureText: _obscurePassword,
                          leading: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              core.LucideIcons.lock,
                              size: 16,
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                _obscurePassword
                                    ? core.LucideIcons.eyeOff
                                    : core.LucideIcons.eye,
                                size: 16,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingresa tu contraseña';
                            }
                            if (value.length < 6) {
                              return 'Mínimo 6 caracteres';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // ── Remember me + Forgot ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                core.ShadCheckbox(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v),
                                  label: Text(
                                    'Recuérdame',
                                    style: theme.textTheme.small,
                                  ),
                                ),
                              ],
                            ),
                            core.ShadButton.ghost(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: theme.textTheme.small.copyWith(
                                  color: const Color(0xFF1A1A1A),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── Login Button ──
                        core.ShadButton(
                          enabled: state is! LoginStateIsLoading,
                          leading: state is LoginStateIsLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
                              )
                            : null,
                          width: double.infinity,
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              final values = _formKey.currentState!.value;
                              final email = values['email'] as String;
                              final password = values['password'] as String;
                              context.read<LoginBloc>().add(LoginEventOnLogin(email: email, pwd: password));
                            }
                          },
                          child: const Text('Iniciar sesión'),
                        ),

                        const SizedBox(height: 16),

                        // ── Divider ──
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'o continúa con',
                                style: theme.textTheme.muted.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ── Google Button ──
                        core.ShadButton.outline(
                          width: double.infinity,
                          onPressed: () {},
                          leading : Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.network(
                              'https://www.google.com/favicon.ico',
                              width: 16,
                              height: 16,
                              errorBuilder: (_, __, ___) => const Icon(
                                core.LucideIcons.globe,
                                size: 16,
                              ),
                            ),
                          ),
                          child: const Text('Continuar con Google'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Sign Up Link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta? ',
                      style: theme.textTheme.muted,
                    ),
                    core.ShadButton.ghost(
                      onPressed: () {
                        // Navigate to CreateAccountScreen
                      },
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Crear cuenta',
                        style: theme.textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      )
    );
  }
}