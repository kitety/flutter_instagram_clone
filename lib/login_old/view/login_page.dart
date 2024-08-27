import 'package:app_ui/app_ui.dart';
import 'package:env/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleSignInButton(),
              SizedBox(height: 12),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  Future<void> _googleSignIn() async {
    final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);
    final iOSClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);
    final googleSigIn = GoogleSignIn(
      clientId: iOSClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSigIn.signIn();
    final googleAuth = await googleUser?.authentication;
    if (googleAuth == null) {
      // logW('Google sign in was canceled');
      throw Exception('Google sign in was canceled');
    }
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    if (accessToken == null) {
      throw Exception('No access token found!');
    }
    if (idToken == null) {
      throw Exception('No id token found!');
    }
    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tappable.scaled(
      borderRadius: BorderRadius.circular(24),
      backgroundColor: context.theme.focusColor,
      scaleStrength: ScaleStrength.xxxs,
      scaleAlignment: Alignment.bottomCenter,
      onTap: () async {
        logI('Tap11');
        try {
          await _googleSignIn();
        } catch (error, stackTrace) {
          logE(
            'Failed to login with Google',
            error: error,
            stackTrace: stackTrace,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          'Google Sign in',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _logout() => Supabase.instance.client.auth.signOut();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          if (session == null) {
            return const SizedBox.shrink();
          }
          return ElevatedButton.icon(
            onPressed: _logout,
            label: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.red),
            ),
            icon: const Icon(Icons.logout),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
