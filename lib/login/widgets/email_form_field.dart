import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:flutter_instagram_clone/login/cubit/login_cubit.dart';
import 'package:shared/shared.dart';

class EmailLoginField extends StatefulWidget {
  const EmailLoginField({super.key});

  @override
  State<EmailLoginField> createState() => _EmailLoginFieldState();
}

class _EmailLoginFieldState extends State<EmailLoginField> {
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
      context.read<LoginCubit>().onEmailUnfocused();
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
    final emailError =
        context.select((LoginCubit cubit) => cubit.state.email.errorMessage);
    return AppTextField(
      filled: true,
      errorText: emailError,
      textController: _controller,
      focusNode: _focusNode,
      hintText: context.l10n.emailText,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        logI('email value $value');
        _debouncer.run(() {
          context.read<LoginCubit>().onEmailChanged(value);
        });
      },
    );
  }
}
