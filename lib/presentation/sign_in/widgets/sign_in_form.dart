import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/application/auth/sign_in_form/sign_in_form_bloc.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
                () {},
                (either) =>
                either.fold(
                      (failure) {
                    FlushbarHelper.createError(message: failure.map(
                        cancelledByUser: (_) => 'Cancelled',
                        serverError: (_) => 'Server error',
                        emailAlreadyInUse: (_) => 'Email already in use',
                        invalidEmailAndPasswordCombination: (_) => 'Invalid Email And Password Combination',)).show(context);
                  },
                      (_) {
                    //navigate to home page
                  },
                ));
      },
      builder: (context, state) {
        return Form(
            autovalidate: state.showErrorMessages,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                const Text(
                  '📝',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 130),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), labelText: 'Email'),
                  autocorrect: false,
                  onChanged: (value) =>
                      context
                          .bloc<SignInFormBloc>()
                          .add(SignInFormEvent.emailChanged(value)),
                  validator: (_) =>
                      context
                          .bloc<SignInFormBloc>()
                          .state
                          .emailAddress
                          .value
                          .fold(
                            (f) =>
                            f.maybeMap(
                              invalidEmail: (_) => 'Invalid Email',
                              orElse: () => null,
                            ),
                            (r) => null,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), labelText: 'Password'),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (value) =>
                      context
                          .bloc<SignInFormBloc>()
                          .add(SignInFormEvent.passwordChanged(value)),
                  validator: (_) =>
                      context
                          .bloc<SignInFormBloc>()
                          .state
                          .password
                          .value
                          .fold(
                            (f) =>
                            f.maybeMap(
                              shortPassword: (_) => 'Invalid Password',
                              orElse: () => null,
                            ),
                            (r) => null,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        child: FlatButton(
                          onPressed: () {
                            context.bloc<SignInFormBloc>().add(
                                const SignInFormEvent
                                    .signInWithEmailAndPasswordPressed());
                          },
                          child: const Text('SIGN IN'),
                        )),
                    Expanded(
                        child: FlatButton(
                          onPressed: () {
                            context.bloc<SignInFormBloc>().add(
                                const SignInFormEvent
                                    .registerWithEmailAndPasswordPressed());
                          },
                          child: const Text('REGISTER'),
                        ))
                  ],
                ),
                RaisedButton(
                    onPressed: () {
                      context
                          .bloc<SignInFormBloc>()
                          .add(const SignInFormEvent.signInWithGooglePressed());
                    },
                    color: Colors.lightBlue,
                    child: Text(
                      'SIGN IN WITH GOOLE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                if(state.isSubmitting)...[
                  const SizedBox(height: 8,),
                  const LinearProgressIndicator(),
                ]
              ],
            ));
      },
    );
  }
}
