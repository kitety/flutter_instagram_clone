import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:flutter_instagram_clone/login/cubit/login_cubit.dart';
import 'package:shared/shared.dart';

class PasswordLoginField extends StatefulWidget {
  const PasswordLoginField({super.key});

  @override
  State<PasswordLoginField> createState() => _PasswordLoginFieldState();
}

class _PasswordLoginFieldState extends State<PasswordLoginField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
    _debouncer = Debouncer();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<LoginCubit>().onPasswordUnfocused();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordError =
        context.select((LoginCubit cubit) => cubit.state.password.errorMessage);
    final showPassword =
        context.select((LoginCubit cubit) => cubit.state.showPassword);
    return AppTextField(
      filled: true,
      obscureText: !showPassword,
      errorText: passwordError,
      textController: _controller,
      focusNode: _focusNode,
      suffixIcon: Tappable(
        onTap: context.read<LoginCubit>().changePasswordVisibility,
        child: Icon(
          showPassword ? Icons.visibility_off : Icons.visibility,
          color: context.customAdaptiveColor(light: AppColors.grey),
        ),
      ),
      hintText: context.l10n.passwordText,
      textInputType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        logI('password value $value');
        _debouncer.run(() {
          context.read<LoginCubit>().onPasswordChanged(value);
        });
      },
    );
  }
}
