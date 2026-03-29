// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'dashboard_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class DashboardLocalizationsEs extends DashboardLocalizations {
  DashboardLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginSubtitle => 'Ingresa a tu cuenta para continuar';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailPlaceholder => 'hola@ejemplo.com';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get rememberMe => 'Recuérdame';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get orContinueWith => 'o continúa con';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get emailRequired => 'Ingresa tu correo';

  @override
  String get emailInvalid => 'Correo inválido';

  @override
  String get passwordRequired => 'Ingresa tu contraseña';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';
}
