import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spending/blocs/expense_bloc.dart';

import 'package:my_spending/blocs/forgot_password_bloc.dart';
import 'package:my_spending/blocs/income_bloc.dart';
import 'package:my_spending/blocs/login_bloc.dart';
import 'package:my_spending/blocs/register_bloc.dart';
import 'package:my_spending/pages/choose_page.dart';
import 'package:my_spending/pages/input_edit_pages/edit_income_page.dart';
import 'package:my_spending/pages/forgot_pass_page.dart';
import 'package:my_spending/pages/input_edit_pages/input_expense_page.dart';
import 'package:my_spending/pages/main_pages/expense_page.dart';
import 'package:my_spending/pages/main_pages/income_page.dart';
import 'package:my_spending/pages/input_edit_pages/input_income_page.dart';
import 'package:my_spending/pages/login_page.dart';
import 'package:my_spending/pages/register_page.dart';


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
  }
}

main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LoginBloc _loginBloc = LoginBloc();
  final RegisterBloc _registerBloc = RegisterBloc();
  final ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();
  final IncomeBloc _incomeBloc = IncomeBloc();
  final ExpenseBloc _expenseBloc = ExpenseBloc();



  @override
  void dispose() {
    _loginBloc.dispose();
    _registerBloc.dispose();
    _forgotPasswordBloc.dispose();
    _incomeBloc.dispose();
    _expenseBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return BlocProviderTree(
        blocProviders: [
          BlocProvider<LoginBloc>(bloc: _loginBloc),
          BlocProvider<RegisterBloc>(bloc: _registerBloc),
          BlocProvider<ForgotPasswordBloc>(bloc: _forgotPasswordBloc),
          BlocProvider<IncomeBloc>(bloc: _incomeBloc),
          BlocProvider<ExpenseBloc>(bloc: _expenseBloc)

        ],
        child: BlocBuilder(
            bloc: _loginBloc,
            builder: (BuildContext context, _) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  routes: {
                    '/': (BuildContext context) => LoginPage(),
                    '/forgot_page': (BuildContext context) => ForgotPasswordPage(),
                    '/register': (BuildContext context) => RegisterPage(),
                    '/choose_page': (BuildContext context) => ChoosePage(),
                    '/income_page': (BuildContext context) => IncomePage(),
                    '/expense_page': (BuildContext context) => ExpensePage(),
                    '/input_income_page': (BuildContext context) => InputIncomePage(),
                    '/input_expense_page': (BuildContext context) => InputExpensePage(),
                    '/edit_income_page': (BuildContext context) => EditIncomePage(),
                    '/edit_expense_page': (BuildContext context) => EditIncomePage(),

                  });
            }
        )
    );
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
