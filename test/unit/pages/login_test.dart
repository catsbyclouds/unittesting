import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:rafeeq_app/lama/login.dart';
import 'package:rafeeq_app/lama/signup.dart';

void main() {
  final mockUser = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'test@example.com',
  );
  final mockAuth = MockFirebaseAuth(mockUser: mockUser);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('LoginPage Widget Tests', () {
     testWidgets('renders all essential elements', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      expect(find.byType(Image), findsWidgets);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forget password '), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Or login with'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
 
    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('shows validation errors for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your Email'), findsOneWidget);
      expect(find.text('Please enter your Password'), findsOneWidget);
    });

    testWidgets('shows email validation error for invalid format',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'invalid-email');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('shows password validation error for short password',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), '123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('accepts valid email and password format - UI only',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');

      final formState = tester.state<FormState>(find.byType(Form));
      expect(formState.validate(), true);
    });
  });

  testWidgets('navigates to signup page when create account clicked',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Loginpage(auth: mockAuth),
      routes: {
        '/signup': (context) => const Signup(),
      },
    ));

    final createAccountFinder = find.text('Create account');

    await tester.ensureVisible(createAccountFinder); // Ensures it's on-screen
    await tester.tap(createAccountFinder);
    await tester.pumpAndSettle();

    expect(find.byType(Signup), findsOneWidget);
  });

  /* group('LoginPage Forget Password Tests', () {
    testWidgets(
        'shows error dialog when forget password tapped with empty email',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.tap(find.text('Forget password '));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Please check your email.'), findsOneWidget);
    });
  }); */

  group('LoginPage Form Validation Edge Cases', () {
    testWidgets('validates email with multiple @ symbols',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@@example.com');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('validates email without domain', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(find.byKey(const Key('emailField')), 'test@');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    /* testWidgets('validates password with exactly 6 characters',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), '123456');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsNothing);
    }); */

    testWidgets('validates password with 5 characters',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), '12345');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });
  });

  group('LoginPage UI Component Tests', () {
    testWidgets('login button has correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      final MaterialButton loginButton =
          tester.widget(find.byType(MaterialButton));
      expect(loginButton.color, const Color(0xff80af81));
      expect(loginButton.textColor, Colors.white);
      expect(loginButton.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('background color is correct', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xffd6efd9));
    });

    testWidgets('form contains SingleChildScrollView',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('email and password fields have correct keys',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
    });

    testWidgets('Google sign-in button is present and styled correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      final ElevatedButton googleButton =
          tester.widget(find.byType(ElevatedButton));
      expect(googleButton.style?.backgroundColor?.resolve({}),
          const Color(0xffd6efd9));
      expect(find.byType(Image), findsWidgets);
    });
  });

  group('LoginPage Text Field Interaction Tests', () {
    testWidgets('can enter text in email field', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'user@example.com');
      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('can enter text in password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');
      final TextFormField passwordField =
          tester.widget(find.byKey(const Key('passwordField')));
      expect(passwordField.controller?.text, 'password123');

      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      final formState = tester.state<FormState>(find.byType(Form));
      expect(formState.validate(), true);
    });

    testWidgets('password field is initially obscured',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      final TextField passwordTextField = tester.widget(find.descendant(
        of: find.byKey(const Key('passwordField')),
        matching: find.byType(TextField),
      ));
      expect(passwordTextField.obscureText, true);
    });

    testWidgets('password field becomes visible when toggle is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      final TextField passwordTextField = tester.widget(find.descendant(
        of: find.byKey(const Key('passwordField')),
        matching: find.byType(TextField),
      ));
      expect(passwordTextField.obscureText, false);
    });
  });

  group('LoginPage Layout Tests', () {
    testWidgets('widgets are arranged in correct order',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      final Column column = tester.widget(find.byType(Column));
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('has proper padding and sizing', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Loginpage(auth: mockAuth)));

      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
