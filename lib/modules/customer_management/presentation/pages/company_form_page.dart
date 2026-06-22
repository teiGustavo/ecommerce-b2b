import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/controllers/company_form/company_form_cubit.dart';
import 'package:ecommerce_b2b/modules/customer_management/presentation/controllers/company_form/company_form_state.dart';

class CompanyFormPage extends StatelessWidget {
  const CompanyFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompanyFormCubit(),
      child: const CompanyFormView(),
    );
  }
}

class CompanyFormView extends StatelessWidget {
  const CompanyFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Empresa')),
      body: BlocListener<CompanyFormCubit, CompanyFormState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Empresa salva com sucesso!')));
            Navigator.of(context).pop();
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
              _LegalNameInput(),
              SizedBox(height: 16),
              _TradeNameInput(),
              SizedBox(height: 16),
              _CnpjInput(),
              SizedBox(height: 16),
              _IeInput(),
              SizedBox(height: 16),
              _EmailInput(),
              SizedBox(height: 16),
              _PhoneInput(),
              SizedBox(height: 16),
              _BillingZipCodeInput(),
              SizedBox(height: 16),
              _ShippingZipCodeInput(),
              SizedBox(height: 16),
              _CreditLimitInput(),
              SizedBox(height: 32),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalNameInput extends StatelessWidget {
  const _LegalNameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.legalName != current.legalName,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_legalNameInput_textField'),
          onChanged: (legalName) => context.read<CompanyFormCubit>().legalNameChanged(legalName),
          decoration: InputDecoration(
            labelText: 'Razão Social',
            errorText: state.legalName.displayError != null ? 'Campo obrigatório' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _TradeNameInput extends StatelessWidget {
  const _TradeNameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.tradeName != current.tradeName,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_tradeNameInput_textField'),
          onChanged: (tradeName) => context.read<CompanyFormCubit>().tradeNameChanged(tradeName),
          decoration: InputDecoration(
            labelText: 'Nome Fantasia',
            errorText: state.tradeName.displayError != null ? 'Campo obrigatório' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _CnpjInput extends StatelessWidget {
  const _CnpjInput();

  @override
  Widget build(BuildContext context) {
    final formatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
    );
    
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.cnpj != current.cnpj,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_cnpjInput_textField'),
          inputFormatters: [formatter],
          keyboardType: TextInputType.number,
          onChanged: (_) => context.read<CompanyFormCubit>().cnpjChanged(formatter.getUnmaskedText()),
          decoration: InputDecoration(
            labelText: 'CNPJ',
            errorText: state.cnpj.displayError != null ? 'CNPJ inválido' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _IeInput extends StatelessWidget {
  const _IeInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.ie != current.ie,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_ieInput_textField'),
          keyboardType: TextInputType.number,
          onChanged: (ie) => context.read<CompanyFormCubit>().ieChanged(ie),
          decoration: InputDecoration(
            labelText: 'Inscrição Estadual',
            errorText: state.ie.displayError != null ? 'IE inválida' : null,
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
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_emailInput_textField'),
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<CompanyFormCubit>().emailChanged(email),
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
    
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_phoneInput_textField'),
          inputFormatters: [formatter],
          keyboardType: TextInputType.phone,
          onChanged: (_) => context.read<CompanyFormCubit>().phoneChanged(formatter.getUnmaskedText()),
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

class _BillingZipCodeInput extends StatelessWidget {
  const _BillingZipCodeInput();

  @override
  Widget build(BuildContext context) {
    final formatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
    );
    
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.billingZipCode != current.billingZipCode,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_billingZipCodeInput_textField'),
          inputFormatters: [formatter],
          keyboardType: TextInputType.number,
          onChanged: (_) => context.read<CompanyFormCubit>().billingZipCodeChanged(formatter.getUnmaskedText()),
          decoration: InputDecoration(
            labelText: 'CEP (Faturamento)',
            errorText: state.billingZipCode.displayError != null ? 'CEP inválido' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _ShippingZipCodeInput extends StatelessWidget {
  const _ShippingZipCodeInput();

  @override
  Widget build(BuildContext context) {
    final formatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
    );
    
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.shippingZipCode != current.shippingZipCode,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_shippingZipCodeInput_textField'),
          inputFormatters: [formatter],
          keyboardType: TextInputType.number,
          onChanged: (_) => context.read<CompanyFormCubit>().shippingZipCodeChanged(formatter.getUnmaskedText()),
          decoration: InputDecoration(
            labelText: 'CEP (Entrega)',
            errorText: state.shippingZipCode.displayError != null ? 'CEP inválido' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _CreditLimitInput extends StatelessWidget {
  const _CreditLimitInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      buildWhen: (previous, current) => previous.creditLimit != current.creditLimit,
      builder: (context, state) {
        return TextField(
          key: const Key('companyForm_creditLimitInput_textField'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (limit) => context.read<CompanyFormCubit>().creditLimitChanged(limit),
          decoration: InputDecoration(
            labelText: 'Limite de Crédito (R\$)',
            errorText: state.creditLimit.displayError != null ? 'Valor inválido' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('companyForm_submitButton'),
                onPressed: state.isValid
                    ? () => context.read<CompanyFormCubit>().submit()
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Salvar Empresa', style: TextStyle(fontSize: 16)),
              );
      },
    );
  }
}
