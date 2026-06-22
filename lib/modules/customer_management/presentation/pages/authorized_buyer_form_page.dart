import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/controllers/authorized_buyer_form/authorized_buyer_form_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/controllers/authorized_buyer_form/authorized_buyer_form_state.dart';

class AuthorizedBuyerFormPage extends StatelessWidget {
  const AuthorizedBuyerFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthorizedBuyerFormCubit(),
      child: const AuthorizedBuyerFormView(),
    );
  }
}

class AuthorizedBuyerFormView extends StatelessWidget {
  const AuthorizedBuyerFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comprador Autorizado')),
      body: BlocListener<AuthorizedBuyerFormCubit, AuthorizedBuyerFormState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Comprador salvo com sucesso!')));
          } else if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Erro ao salvar')));
          }
        },
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FullNameInput(),
              SizedBox(height: 16),
              _EmailInput(),
              SizedBox(height: 16),
              _PhoneInput(),
              SizedBox(height: 16),
              _PositionTitleInput(),
              SizedBox(height: 16),
              _ActiveSwitch(),
              SizedBox(height: 32),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  const _FullNameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizedBuyerFormCubit, AuthorizedBuyerFormState>(
      buildWhen: (previous, current) => previous.fullName != current.fullName,
      builder: (context, state) {
        return TextField(
          key: const Key('buyerForm_fullNameInput_textField'),
          onChanged: (fullName) => context.read<AuthorizedBuyerFormCubit>().fullNameChanged(fullName),
          decoration: InputDecoration(
            labelText: 'Nome Completo',
            errorText: state.fullName.displayError != null ? 'Campo obrigatório' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizedBuyerFormCubit, AuthorizedBuyerFormState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('buyerForm_emailInput_textField'),
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<AuthorizedBuyerFormCubit>().emailChanged(email),
          decoration: InputDecoration(
            labelText: 'E-mail',
            errorText: state.email.displayError != null ? 'E-mail inválido' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput();

  @override
  Widget build(BuildContext context) {
    final formatter = MaskTextInputFormatter(
      mask: '+55 (##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );
    
    return BlocBuilder<AuthorizedBuyerFormCubit, AuthorizedBuyerFormState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextField(
          key: const Key('buyerForm_phoneInput_textField'),
          inputFormatters: [formatter],
          keyboardType: TextInputType.phone,
          onChanged: (_) => context.read<AuthorizedBuyerFormCubit>().phoneChanged(formatter.getUnmaskedText()),
          decoration: InputDecoration(
            labelText: 'Telefone',
            errorText: state.phone.displayError != null ? 'Telefone inválido' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _PositionTitleInput extends StatelessWidget {
  const _PositionTitleInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizedBuyerFormCubit, AuthorizedBuyerFormState>(
      buildWhen: (previous, current) => previous.positionTitle != current.positionTitle,
      builder: (context, state) {
        return TextField(
          key: const Key('buyerForm_positionTitleInput_textField'),
          onChanged: (position) => context.read<AuthorizedBuyerFormCubit>().positionTitleChanged(position),
          decoration: InputDecoration(
            labelText: 'Cargo',
            errorText: state.positionTitle.displayError != null ? 'Campo obrigatório' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _ActiveSwitch extends StatelessWidget {
  const _ActiveSwitch();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizedBuyerFormCubit, AuthorizedBuyerFormState>(
      buildWhen: (previous, current) => previous.active != current.active,
      builder: (context, state) {
        return SwitchListTile(
          title: const Text('Cadastro Ativo'),
          value: state.active,
          onChanged: (active) => context.read<AuthorizedBuyerFormCubit>().activeChanged(active),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizedBuyerFormCubit, AuthorizedBuyerFormState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('buyerForm_submitButton'),
                onPressed: state.isValid
                    ? () => context.read<AuthorizedBuyerFormCubit>().submit()
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Salvar Comprador', style: TextStyle(fontSize: 16)),
              );
      },
    );
  }
}
