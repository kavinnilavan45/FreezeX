import 'package:flutter/material.dart';
import 'payment_engine.dart';
import 'api_service.dart';

void main() {
  runApp(const FreezeXApp());
}

class FreezeXApp extends StatelessWidget {
  const FreezeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreezeX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        fontFamily: 'Arial',
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// GLOBAL LOGOUT
// ============================================================

Map<String, dynamic>? completedPayment;
String? completedFreelancer;
String? completedProject;

void logout(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
    (route) => false,
  );
}

// ============================================================
// ROLE SELECTION
// ============================================================

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const SizedBox(height: 35),

                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(.25),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'FreezeX',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Lock the rate. Move the money.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 50),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'How are you using FreezeX?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _RoleCard(
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Admin',
                    subtitle:
                        'Manage clients, freelancers, subscriptions and payments.',
                    color: const Color(0xFF7C3AED),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminLoginPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _RoleCard(
                    icon: Icons.business_rounded,
                    title: 'Client',
                    subtitle: 'Send payments to freelancers across borders.',
                    color: const Color(0xFF2563EB),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(role: 'Client'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _RoleCard(
                    icon: Icons.person_rounded,
                    title: 'Freelancer',
                    subtitle:
                        'Receive international payments with transparent FX.',
                    color: const Color(0xFF059669),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(role: 'Freelancer'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Secure • Transparent • No hidden FX markup',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ROLE CARD
// ============================================================

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.privacy_tip_outlined),
                    label: const Text('Privacy Policy & Platform Terms'),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 17,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN
// ============================================================

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain at least 6 characters.'),
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
        role: widget.role,
      );

      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Welcome ${result['name']}!')));

      if (widget.role == 'Client') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SubscriptionPage(
              clientId: (result['id'] as num?)?.toInt() ?? 1,
              userName: result['name']?.toString() ?? 'Client',
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FreelancerDashboard(
              userName: result['name']?.toString() ?? 'Freelancer',
              email: result['email']?.toString() ?? email,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      String message = e.toString();

      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClient = widget.role == 'Client';
    return Scaffold(
      appBar: AppBar(title: Text('${widget.role} Login'), elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 470),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isClient
                      ? 'Welcome back, Client'
                      : 'Welcome back, Freelancer',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue to FreezeX.',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                ),
                const SizedBox(height: 35),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: login,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignupPage(role: widget.role),
                      ),
                    ),
                    child: const Text('Create a new account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SIGNUP
// ============================================================

class SignupPage extends StatefulWidget {
  final String role;

  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();
  final companyController = TextEditingController();
  final companyTypeController = TextEditingController();
  final businessController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final aboutController = TextEditingController();
  final lookingForController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool policyAccepted = false;

  bool get isClient => widget.role.toLowerCase() == 'client';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    countryController.dispose();
    phoneController.dispose();
    companyController.dispose();
    companyTypeController.dispose();
    businessController.dispose();
    skillsController.dispose();
    experienceController.dispose();
    aboutController.dispose();
    lookingForController.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration(
    String label,
    IconData icon, {
    String? hint,
    String? helper,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget sectionHeader(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();
    final country = countryController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty) return _showError('Please enter your full name.');
    if (email.isEmpty || !email.contains('@')) {
      return _showError('Please enter a valid email address.');
    }
    if (phone.isEmpty) return _showError('Please enter your phone number.');
    if (country.isEmpty) return _showError('Please enter your country.');
    if (password.length < 6) {
      return _showError('Password must contain at least 6 characters.');
    }
    if (password != confirm) return _showError('Passwords do not match.');

    if (isClient) {
      if (companyController.text.trim().isEmpty) {
        return _showError('Please enter your company name.');
      }
      if (companyTypeController.text.trim().isEmpty) {
        return _showError('Please enter your company type.');
      }
      if (businessController.text.trim().isEmpty) {
        return _showError('Please describe your business or project needs.');
      }
    } else {
      if (skillsController.text.trim().isEmpty) {
        return _showError('Please enter your skills.');
      }
      if (experienceController.text.trim().isEmpty) {
        return _showError('Please enter your experience.');
      }
      if (aboutController.text.trim().isEmpty) {
        return _showError('Please tell us a little about yourself.');
      }
      if (lookingForController.text.trim().isEmpty) {
        return _showError('Please tell us what work you are looking for.');
      }
    }

    if (!policyAccepted) {
      return _showError(
        'Please read and accept the Privacy Policy & Platform Terms.',
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await ApiService.signup(
        name: name,
        email: email,
        password: password,
        role: widget.role,
        country: country,
        phone: phone,
        companyName: companyController.text.trim(),
        companyType: companyTypeController.text.trim(),
        businessDescription: businessController.text.trim(),
        skills: skillsController.text.trim(),
        experience: experienceController.text.trim(),
        about: aboutController.text.trim(),
        lookingFor: lookingForController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ??
                'Account created successfully. Please login.',
          ),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage(role: widget.role)),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      var message = e.toString();
      if (message.startsWith('Exception: ')) message = message.substring(11);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = isClient
        ? const Color(0xFF2563EB)
        : const Color(0xFF059669);

    return Scaffold(
      appBar: AppBar(title: Text('${widget.role} Registration')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(.08),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: roleColor.withOpacity(.18)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: roleColor.withOpacity(.13),
                        child: Icon(
                          isClient
                              ? Icons.business_rounded
                              : Icons.person_rounded,
                          color: roleColor,
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isClient
                                  ? 'Client Registration'
                                  : 'Freelancer Registration',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isClient
                                  ? 'Tell us about your company so you can post and manage projects.'
                                  : 'Build your professional profile so you can discover relevant projects.',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                sectionHeader(
                  'Account & Identity',
                  'Basic information used for your FreezeX account and verification flow.',
                  Icons.verified_user_outlined,
                ),
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: fieldDecoration(
                    'Full Name *',
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: fieldDecoration(
                    'Email Address *',
                    Icons.email_outlined,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: fieldDecoration(
                    'Phone Number *',
                    Icons.phone_outlined,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: countryController,
                  textCapitalization: TextCapitalization.words,
                  decoration: fieldDecoration(
                    'Country *',
                    Icons.public_outlined,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: fieldDecoration('Password *', Icons.lock_outline)
                      .copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: confirmController,
                  obscureText: obscureConfirm,
                  decoration:
                      fieldDecoration(
                        'Confirm Password *',
                        Icons.lock_reset_outlined,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => obscureConfirm = !obscureConfirm),
                          icon: Icon(
                            obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 28),
                sectionHeader(
                  isClient ? 'Company Details' : 'Professional Profile',
                  isClient
                      ? 'These details help clients describe who they are and what they need.'
                      : 'These details help clients find freelancers with the right skills and experience.',
                  isClient ? Icons.domain_outlined : Icons.work_outline_rounded,
                ),
                if (isClient) ...[
                  TextField(
                    controller: companyController,
                    decoration: fieldDecoration(
                      'Company Name *',
                      Icons.business_outlined,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: companyTypeController,
                    decoration: fieldDecoration(
                      'Company Type *',
                      Icons.category_outlined,
                      hint: 'Startup, Agency, Enterprise, etc.',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: businessController,
                    maxLines: 4,
                    decoration: fieldDecoration(
                      'Business / Project Description *',
                      Icons.description_outlined,
                      helper:
                          'Briefly describe your business and the kind of projects you may post.',
                    ),
                  ),
                ] else ...[
                  TextField(
                    controller: skillsController,
                    decoration: fieldDecoration(
                      'Skills *',
                      Icons.code_outlined,
                      hint: 'Flutter, Dart, Python, UI/UX',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: experienceController,
                    decoration: fieldDecoration(
                      'Experience *',
                      Icons.work_history_outlined,
                      hint: '2 years, 5 years, Entry level, etc.',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: aboutController,
                    maxLines: 4,
                    decoration: fieldDecoration(
                      'About You *',
                      Icons.person_outline,
                      helper:
                          'Describe your professional background and strengths.',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: lookingForController,
                    maxLines: 3,
                    decoration: fieldDecoration(
                      'What Work Are You Looking For? *',
                      Icons.search_rounded,
                      helper:
                          'Mention preferred project types, technologies or domains.',
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: CheckboxListTile(
                    value: policyAccepted,
                    onChanged: (value) =>
                        setState(() => policyAccepted = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'I have read and accept the Privacy Policy & Platform Terms.',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      child: const Text('View Privacy Policy & Platform Terms'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: createAccount,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '* Required fields • FreezeX uses this information for account, marketplace and compliance workflows.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SUBSCRIPTION
// ============================================================

class SubscriptionPage extends StatelessWidget {
  final int clientId;
  final String userName;

  const SubscriptionPage({
    super.key,
    required this.clientId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreezeX Subscription'),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFF2563EB),
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'FreezeX Business',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'One simple subscription for your payment infrastructure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF64748B), height: 1.5),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CLIENT ACCOUNT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.person_rounded,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.badge_rounded,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Client ID: $clientId',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    '\$99',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2563EB),
                    ),
                  ),

                  const Text(
                    '/ month',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),

                  const SizedBox(height: 25),

                  const _SubscriptionFeature(
                    text: 'Cross-border payment infrastructure',
                  ),
                  const _SubscriptionFeature(
                    text: 'Transparent FX rate locking',
                  ),
                  const _SubscriptionFeature(
                    text: 'Compliance and fraud workflow',
                  ),
                  const _SubscriptionFeature(
                    text: 'Payment routing optimization',
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClientDashboard(
                              clientId: clientId,
                              userName: userName,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Activate Business Plan',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Illustrative hackathon pricing',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionFeature extends StatelessWidget {
  final String text;

  const _SubscriptionFeature({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF059669),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

// ============================================================
// POLISHED CLIENT DASHBOARD
// ============================================================

class ClientDashboard extends StatefulWidget {
  final int clientId;
  final String userName;

  const ClientDashboard({
    super.key,
    required this.clientId,
    this.userName = 'Client',
  });

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  Map<String, dynamic>? dashboard;
  bool loadingDashboard = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final result = await ApiService.getClientDashboard(widget.clientId);
      if (!mounted) return;
      setState(() {
        dashboard = result;
        loadingDashboard = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loadingDashboard = false);
    }
  }

  Future<void> openHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TransactionHistoryPage(role: 'client', clientId: widget.clientId),
      ),
    );
    loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = dashboard?['transaction_count']?.toString() ?? '0';
    final totalUsd = dashboard?['total_usd'] is num
        ? (dashboard!['total_usd'] as num).toDouble()
        : double.tryParse('${dashboard?['total_usd'] ?? 0}') ?? 0;
    final pending = dashboard?['pending_count']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            const Text(
              'FreezeX',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Transaction History',
            onPressed: openHistory,
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 45 : 20,
              vertical: 28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${widget.userName} 👋',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Client Dashboard',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage your international payments with complete transparency.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Client ID: ${widget.clientId}',
                        style: const TextStyle(
                          color: Color(0xFF1D4ED8),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (loadingDashboard)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (!loadingDashboard) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _DashboardStat(
                              title: 'Transactions',
                              value: transactions,
                              icon: Icons.swap_horiz_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DashboardStat(
                              title: 'Total Sent',
                              value: '\$${totalUsd.toStringAsFixed(2)}',
                              icon: Icons.attach_money_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DashboardStat(
                              title: 'Pending',
                              value: pending,
                              icon: Icons.schedule_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cross-Border Payments',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Send money with the rate locked upfront.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '₹0 freelancer fee • 0% FX markup • transparent settlement',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.14),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Automatic payment: when the freelancer completes an accepted project, FreezeX triggers the payment flow automatically. No manual payment creation is required.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      height: 1.4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: openHistory,
                        icon: const Icon(Icons.history_rounded),
                        label: const Text(
                          'Transaction History',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProjectPostPage(clientId: widget.clientId),
                          ),
                        ),
                        icon: const Icon(Icons.post_add_rounded),
                        label: const Text(
                          'Post / Manage Projects',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _InfoCard(
                      icon: Icons.shield_rounded,
                      title: 'Transparent by design',
                      text:
                          'Identity, compliance, fraud checks, FX rate and settlement status are traceable.',
                    ),
                    const SizedBox(height: 12),
                    const _InfoCard(
                      icon: Icons.lock_clock_rounded,
                      title: 'Rate locked upfront',
                      text:
                          'The displayed FX rate is captured when you freeze the payment.',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF059669)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD STAT
// ============================================================

// ============================================================
// DASHBOARD FEATURE
// ============================================================

class _DashboardFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DashboardFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RECENT PAYMENT
// ============================================================

class _RecentPayment extends StatelessWidget {
  final String name;
  final String project;
  final String usd;
  final String inr;
  final String status;
  final Color statusColor;

  const _RecentPayment({
    required this.name,
    required this.project,
    required this.usd,
    required this.inr,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: const Color(0xFFEFF6FF),
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  project,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      usd,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      inr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CREATE PAYMENT
// ============================================================

class CreatePaymentPage extends StatefulWidget {
  final int clientId;

  const CreatePaymentPage({super.key, required this.clientId});

  @override
  State<CreatePaymentPage> createState() => _CreatePaymentPageState();
}

class _CreatePaymentPageState extends State<CreatePaymentPage> {
  final amountController = TextEditingController(text: '500');

  String freelancer = 'Arjun Kumar';
  String project = 'Website Development';

  Map<String, dynamic>? paymentData;
  double? liveFxRate;
  bool loadingRate = false;
  bool freezingRate = false;
  DateTime? rateUpdatedAt;

  @override
  void initState() {
    super.initState();
    loadLiveRate();
  }

  String _freelancerEmail(String name) {
    switch (name) {
      case 'Priya Sharma':
        return 'priya@example.com';
      case 'Rahul Verma':
        return 'rahul@example.com';
      default:
        return 'arjun@example.com';
    }
  }

  Future<void> loadLiveRate() async {
    setState(() => loadingRate = true);

    try {
      final result = await ApiService.getLiveFxRate();
      if (!mounted) return;

      setState(() {
        liveFxRate = (result['rate'] as num).toDouble();
        rateUpdatedAt = DateTime.now();
        loadingRate = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loadingRate = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load live FX rate: $e')),
      );
    }
  }

  Future<void> freezeRate() async {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid USD amount.')),
      );
      return;
    }

    setState(() => freezingRate = true);

    try {
      // Create the payment through the FastAPI backend.
      final created = await ApiService.createPayment(
        clientId: widget.clientId,
        freelancerName: freelancer,
        freelancerEmail: _freelancerEmail(freelancer),
        country: 'India',
        amountUsd: amount,
        project: project,
        identityVerified: true,
      );

      final paymentId = created['payment_id'].toString();
      final payment = Map<String, dynamic>.from(created['payment'] as Map);
      final fx = Map<String, dynamic>.from(created['fx'] as Map);
      final route = Map<String, dynamic>.from(created['route'] as Map);
      final compliance = Map<String, dynamic>.from(
        created['compliance'] as Map,
      );
      final fraud = Map<String, dynamic>.from(created['fraud'] as Map);

      final lockedRate = (fx['rate'] as num).toDouble();
      final inrAmount = (payment['amount_inr'] as num).toDouble();

      // Lock the exact backend quote.
      final locked = await ApiService.lockFxRate(
        paymentId: paymentId,
        amountUsd: amount,
        fxRate: lockedRate,
      );

      final lockedFx = Map<String, dynamic>.from(locked['fx'] as Map);
      final lock = Map<String, dynamic>.from(locked['lock'] as Map);

      final data = <String, dynamic>{
        'paymentId': paymentId,
        'clientId': widget.clientId,
        'usdAmount': amount,
        'inrAmount': (locked['payment']['amount_inr'] as num).toDouble(),
        'fxRate': (lockedFx['locked_rate'] as num).toDouble(),
        'liveFxRate': lockedRate,
        'rateLockedAt': lock['locked_at'].toString(),
        'rateStatus': lockedFx['status'].toString(),
        'status': 'RATE LOCKED - READY FOR SETTLEMENT',
        'compliance': {
          'status': created['status'] == 'READY_FOR_RATE_LOCK'
              ? 'APPROVED'
              : compliance['kyc'].toString(),
          ...compliance,
        },
        'fraud': fraud,
        'route': {
          'route': route['selected'],
          'fee': (route['infrastructure_cost'] as num).toDouble(),
          'time': (route['estimated_minutes'] as num).toDouble(),
          'risk': (route['risk'] as num).toDouble(),
        },
        'clientFee': 0.0,
        'freelancerFee': 0.0,
        'fxMarkup': 0.0,
        'hiddenCharges': 0.0,
        'simulation': true,
      };

      if (!mounted) return;

      setState(() {
        paymentData = data;
        liveFxRate = lockedRate;
        rateUpdatedAt = DateTime.now();
        freezingRate = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConversionPage(
            paymentData: data,
            freelancer: freelancer,
            project: project,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => freezingRate = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to freeze FX rate: $e')));
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = paymentData;
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final previewRate = liveFxRate ?? 0;
    final estimatedInr = amount * previewRate;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a Payment',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get the live market rate, review the payout, then lock the quote before settlement.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: freelancer,
                        decoration: InputDecoration(
                          labelText: 'Freelancer',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Arjun Kumar',
                            child: Text('Arjun Kumar'),
                          ),
                          DropdownMenuItem(
                            value: 'Priya Sharma',
                            child: Text('Priya Sharma'),
                          ),
                          DropdownMenuItem(
                            value: 'Rahul Verma',
                            child: Text('Rahul Verma'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => freelancer = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: project,
                        decoration: InputDecoration(
                          labelText: 'Project',
                          prefixIcon: const Icon(Icons.work_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Website Development',
                            child: Text('Website Development'),
                          ),
                          DropdownMenuItem(
                            value: 'UI/UX Design',
                            child: Text('UI/UX Design'),
                          ),
                          DropdownMenuItem(
                            value: 'Mobile App Development',
                            child: Text('Mobile App Development'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => project = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Amount in USD',
                          prefixText: '\$ ',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.currency_exchange_rounded,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Live USD → INR Rate',
                              style: TextStyle(
                                color: Color(0xFF1E40AF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Refresh live rate',
                            onPressed: loadingRate || freezingRate
                                ? null
                                : loadLiveRate,
                            icon: loadingRate
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.refresh_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        previewRate > 0
                            ? '₹${previewRate.toStringAsFixed(2)} / USD'
                            : 'Loading live rate...',
                        style: const TextStyle(
                          color: Color(0xFF1D4ED8),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        rateUpdatedAt == null
                            ? 'Fetching current market quote...'
                            : 'Updated just now • This rate is not locked yet',
                        style: const TextStyle(color: Color(0xFF475569)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      const Divider(),
                      const SizedBox(height: 12),
                      const Text(
                        'Estimated Freelancer Payout',
                        style: TextStyle(
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        previewRate > 0
                            ? '₹${estimatedInr.toStringAsFixed(2)}'
                            : '—',
                        style: const TextStyle(
                          color: Color(0xFF059669),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (data != null) ...[
                  _PaymentInfo(label: 'Client Fee', value: '\$0.00'),
                  _PaymentInfo(label: 'Freelancer Fee', value: '₹0.00'),
                  _PaymentInfo(label: 'FX Markup', value: '0%'),
                  _PaymentInfo(label: 'Hidden Charges', value: '₹0.00'),
                  const SizedBox(height: 15),
                  _StatusCard(
                    title: 'Compliance',
                    value: data['compliance']['status'].toString(),
                    icon: Icons.verified_user_rounded,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _StatusCard(
                    title: 'Fraud Risk',
                    value: data['fraud']['decision'].toString(),
                    icon: Icons.security_rounded,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _StatusCard(
                    title: 'Recommended Route',
                    value: data['route']['route'].toString(),
                    icon: Icons.alt_route_rounded,
                    color: const Color(0xFF2563EB),
                  ),
                ],

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton.icon(
                    onPressed: freezingRate || loadingRate || liveFxRate == null
                        ? null
                        : freezeRate,
                    icon: freezingRate
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.lock_rounded),
                    label: Text(
                      freezingRate
                          ? 'Locking Live Rate...'
                          : 'FREEZE LIVE RATE',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Once frozen, the quoted rate stays attached to this transaction.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PAYMENT INFO
// ============================================================

class _PaymentInfo extends StatelessWidget {
  final String label;
  final String value;

  const _PaymentInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

// ============================================================
// STATUS CARD
// ============================================================

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: color.withOpacity(.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CONVERSION PAGE
// ============================================================

class ConversionPage extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  final String freelancer;
  final String project;

  const ConversionPage({
    super.key,
    required this.paymentData,
    required this.freelancer,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final usd = paymentData['usdAmount'] as double;
    final inr = paymentData['inrAmount'] as double;
    final fxRate = paymentData['fxRate'] as double;

    return Scaffold(
      appBar: AppBar(title: const Text('FX Conversion')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              children: [
                const Icon(
                  Icons.lock_clock_rounded,
                  color: Color(0xFF2563EB),
                  size: 65,
                ),

                const SizedBox(height: 18),

                const Text(
                  'Rate Locked',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 8),

                const Text(
                  'The exchange rate is locked before settlement.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '\$${usd.toStringAsFixed(2)} USD',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Icon(
                        Icons.arrow_downward_rounded,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '₹${inr.toStringAsFixed(2)} INR',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF059669),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      _InfoRow(
                        label: 'Locked Rate',
                        value: '₹${fxRate.toStringAsFixed(2)} / USD',
                      ),
                      const _InfoRow(label: 'FX Markup', value: '0%'),
                      const _InfoRow(
                        label: 'User Transaction Fee',
                        value: '₹0',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompliancePage(
                            paymentData: paymentData,
                            freelancer: freelancer,
                            project: project,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Confirm & Freeze',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INFO ROW
// ============================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ============================================================
// COMPLIANCE
// ============================================================

class CompliancePage extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  final String freelancer;
  final String project;

  const CompliancePage({
    super.key,
    required this.paymentData,
    required this.freelancer,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identity & Compliance')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Compliance Check',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 8),

                const Text(
                  'FreezeX validates the participants before settlement.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 25),

                const _ComplianceCheck(
                  title: 'Identity Verification',
                  subtitle: 'Identity verified',
                ),

                const _ComplianceCheck(
                  title: 'KYC Check',
                  subtitle: 'KYC passed',
                ),

                const _ComplianceCheck(
                  title: 'AML Screening',
                  subtitle: 'AML screening passed',
                ),

                const _ComplianceCheck(
                  title: 'Fraud Risk',
                  subtitle: 'Low risk',
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: const Text(
                    'Prototype notice: identity, KYC, AML and fraud '
                    'checks are simulated for the hackathon demo.',
                    style: TextStyle(color: Color(0xFF9A3412), height: 1.45),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SmartRoutePage(
                            paymentData: paymentData,
                            freelancer: freelancer,
                            project: project,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComplianceCheck extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ComplianceCheck({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.check_rounded, color: Color(0xFF059669)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'VERIFIED',
            style: TextStyle(
              color: Color(0xFF059669),
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SMART ROUTE
// ============================================================

class SmartRoutePage extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  final String freelancer;
  final String project;

  const SmartRoutePage({
    super.key,
    required this.paymentData,
    required this.freelancer,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final route = PaymentEngine.findBestRoute();

    return Scaffold(
      appBar: AppBar(title: const Text('Route Optimization')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smart Routing',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 8),

                const Text(
                  'FreezeX evaluates available settlement routes.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFECFDF5), Color(0xFFF0FDFA)],
                    ),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RECOMMENDED ROUTE',
                        style: TextStyle(
                          color: Color(0xFF047857),
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: .7,
                        ),
                      ),

                      const SizedBox(height: 9),

                      Text(
                        route['route'].toString(),
                        style: const TextStyle(
                          color: Color(0xFF065F46),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _RouteMetric(
                              title: 'Infrastructure Fee',
                              value:
                                  '\$${(route['fee'] as double).toStringAsFixed(2)}',
                            ),
                          ),
                          Expanded(
                            child: _RouteMetric(
                              title: 'Estimated Time',
                              value:
                                  '${(route['time'] as double).toStringAsFixed(0)} min',
                            ),
                          ),
                          Expanded(
                            child: _RouteMetric(
                              title: 'Risk Score',
                              value: (route['risk'] as double).toStringAsFixed(
                                1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const _RouteStep(
                  icon: Icons.flag_outlined,
                  title: 'USA',
                  subtitle: 'Payment initiated',
                ),

                const _RouteArrow(),

                const _RouteStep(
                  icon: Icons.currency_bitcoin_rounded,
                  title: 'USDC',
                  subtitle: 'Bridge / settlement asset',
                ),

                const _RouteArrow(),

                const _RouteStep(
                  icon: Icons.account_balance_rounded,
                  title: 'INDIA',
                  subtitle: 'INR payout',
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SmartContractPage(
                            paymentData: paymentData,
                            freelancer: freelancer,
                            project: project,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Lock Route & Continue',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  final String title;
  final String value;

  const _RouteMetric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF065F46),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _RouteStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _RouteStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: const Color(0xFFEFF6FF),
            child: Icon(icon, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteArrow extends StatelessWidget {
  const _RouteArrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Center(
        child: Icon(Icons.arrow_downward_rounded, color: Color(0xFF94A3B8)),
      ),
    );
  }
}

// ============================================================
// SMART CONTRACT
// ============================================================

class SmartContractPage extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  final String freelancer;
  final String project;

  const SmartContractPage({
    super.key,
    required this.paymentData,
    required this.freelancer,
    required this.project,
  });

  @override
  State<SmartContractPage> createState() => _SmartContractPageState();
}

class _SmartContractPageState extends State<SmartContractPage> {
  bool creating = false;

  String _freelancerEmail(String name) {
    switch (name) {
      case 'Priya Sharma':
        return 'priya@example.com';
      case 'Rahul Verma':
        return 'rahul@example.com';
      default:
        return 'arjun@example.com';
    }
  }

  Map<String, dynamic>? contractData;

  Future<void> createContract() async {
    if (creating) return;

    final paymentId = widget.paymentData['paymentId']?.toString();
    if (paymentId == null || paymentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Payment ID is missing. Please create the payment again.',
          ),
        ),
      );
      return;
    }

    setState(() => creating = true);

    try {
      final result = await ApiService.createSmartContract(
        paymentId: paymentId,
        amountUsd: (widget.paymentData['usdAmount'] as num).toDouble(),
        amountInr: (widget.paymentData['inrAmount'] as num).toDouble(),
        fxRate: (widget.paymentData['fxRate'] as num).toDouble(),
        freelancerName: widget.freelancer,
        freelancerEmail: _freelancerEmail(widget.freelancer),
        project: widget.project,
      );

      if (!mounted) return;

      final updated = <String, dynamic>{
        ...widget.paymentData,
        'smartContract': result,
        'smartContractStatus': result['status']?.toString() ?? 'CREATED',
        'status': 'SMART CONTRACT READY',
      };

      setState(() {
        contractData = result;
        creating = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SettlementPage(
            paymentData: updated,
            freelancer: widget.freelancer,
            project: widget.project,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => creating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Smart contract creation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentId = widget.paymentData['paymentId']?.toString() ?? '—';
    final usd = (widget.paymentData['usdAmount'] as num).toDouble();
    final inr = (widget.paymentData['inrAmount'] as num).toDouble();
    final fxRate = (widget.paymentData['fxRate'] as num).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Contract')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_tree_rounded,
                    color: Color(0xFF2563EB),
                    size: 44,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Smart Contract',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create the programmable payment instruction before settlement.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(label: 'Payment ID', value: paymentId),
                      _InfoRow(
                        label: 'USD Amount',
                        value: '\$${usd.toStringAsFixed(2)}',
                      ),
                      _InfoRow(
                        label: 'INR Payout',
                        value: '₹${inr.toStringAsFixed(2)}',
                      ),
                      _InfoRow(
                        label: 'Locked FX Rate',
                        value: '₹${fxRate.toStringAsFixed(2)} / USD',
                      ),
                      _InfoRow(label: 'Freelancer', value: widget.freelancer),
                      _InfoRow(label: 'Project', value: widget.project),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFEA580C),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Hackathon prototype: this API creates a simulated smart-contract record. No real blockchain transaction is submitted.',
                          style: TextStyle(
                            color: Color(0xFF9A3412),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (contractData != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Text(
                      'Contract created successfully\n\nContract ID: ${contractData!['contract_id'] ?? '—'}\nTransaction Hash: ${contractData!['transaction_hash'] ?? '—'}',
                      style: const TextStyle(
                        color: Color(0xFF065F46),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton.icon(
                    onPressed: creating ? null : createContract,
                    icon: creating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.account_tree_rounded),
                    label: Text(
                      creating
                          ? 'Creating Contract...'
                          : 'CREATE SMART CONTRACT',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SETTLEMENT
// ============================================================

String _simulatedTransactionHash(String paymentId, String contractId) {
  final seed = '$paymentId|$contractId';
  var value = 0x811C9DC5;
  for (final unit in seed.codeUnits) {
    value ^= unit;
    value = (value * 0x01000193) & 0xFFFFFFFF;
  }

  final first = value.toRadixString(16).padLeft(8, '0');
  final second = (value ^ 0xA5A5A5A5).toRadixString(16).padLeft(8, '0');
  final third = (value * 2654435761 & 0xFFFFFFFF)
      .toRadixString(16)
      .padLeft(8, '0');
  final fourth = (value ^ 0x5A5A5A5A).toRadixString(16).padLeft(8, '0');
  final fifth = (value + 0x12345678 & 0xFFFFFFFF)
      .toRadixString(16)
      .padLeft(8, '0');
  final sixth = (value * 17 & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0');
  final seventh = (value ^ 0xDEADBEEF).toRadixString(16).padLeft(8, '0');
  final eighth = (value + 0xCAFEBABE & 0xFFFFFFFF)
      .toRadixString(16)
      .padLeft(8, '0');

  return '0x$first$second$third$fourth$fifth$sixth$seventh$eighth';
}

String _displaySmartValue(Map<String, dynamic> source, List<String> keys) {
  Map<String, dynamic> current = source;

  for (final key in const [
    'contract',
    'data',
    'smart_contract',
    'contract_data',
    'blockchain',
    'result',
  ]) {
    final nested = source[key];
    if (nested is Map) {
      current = Map<String, dynamic>.from(nested);
      break;
    }
  }

  for (final key in keys) {
    final value = current[key] ?? source[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }

  return '—';
}

class SettlementPage extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  final String freelancer;
  final String project;

  const SettlementPage({
    super.key,
    required this.paymentData,
    required this.freelancer,
    required this.project,
  });

  @override
  State<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  bool settling = false;

  String _freelancerEmail(String name) {
    switch (name) {
      case 'Priya Sharma':
        return 'priya@example.com';
      case 'Rahul Verma':
        return 'rahul@example.com';
      default:
        return 'arjun@example.com';
    }
  }

  Future<void> executeSettlement() async {
    if (settling) return;

    final paymentId = widget.paymentData['paymentId']?.toString();
    final smart = widget.paymentData['smartContract'];

    if (paymentId == null || paymentId.isEmpty || smart is! Map) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Smart contract information is missing.')),
      );
      return;
    }

    final contract = Map<String, dynamic>.from(smart);

    // Backend responses can be returned either directly or inside a
    // nested `contract`/`data` object. Normalize the values here so the
    // Settlement screen always receives the actual identifiers.
    Map<String, dynamic> normalizedContract = contract;

    for (final key in const [
      'contract',
      'data',
      'smart_contract',
      'contract_data',
      'blockchain',
      'result',
    ]) {
      final nested = contract[key];
      if (nested is Map) {
        normalizedContract = Map<String, dynamic>.from(nested);
        break;
      }
    }

    String? firstString(List<String> keys) {
      for (final key in keys) {
        final value = normalizedContract[key] ?? contract[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return null;
    }

    final contractId = firstString([
      'contract_id',
      'contractId',
      'contractID',
      'id',
    ]);

    final extractedTransactionHash = firstString([
      'transaction_hash',
      'transactionHash',
      'tx_hash',
      'txHash',
      'hash',
      'blockchain_tx_hash',
      'txHashHex',
    ]);

    if (contractId == null || contractId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Smart contract ID is missing. Please create the contract again.',
          ),
        ),
      );
      return;
    }

    // The hackathon backend may return a simulated contract ID without a
    // transaction hash. Generate a deterministic-looking simulated hash so
    // the settlement API can complete the prototype flow.
    final transactionHash =
        (extractedTransactionHash != null &&
            extractedTransactionHash.trim().isNotEmpty)
        ? extractedTransactionHash
        : _simulatedTransactionHash(paymentId, contractId);

    setState(() => settling = true);

    try {
      final result = await ApiService.settlePayment(
        paymentId: paymentId,
        amountUsd: (widget.paymentData['usdAmount'] as num).toDouble(),
        amountInr: (widget.paymentData['inrAmount'] as num).toDouble(),
        fxRate: (widget.paymentData['fxRate'] as num).toDouble(),
        contractId: contractId,
        transactionHash: transactionHash,
        freelancerName: widget.freelancer,
        freelancerEmail: _freelancerEmail(widget.freelancer),
        project: widget.project,
      );

      if (!mounted) return;

      final updated = <String, dynamic>{
        ...widget.paymentData,
        'settlement': result,
        'status': 'COMPLETED',
      };

      completedPayment = Map<String, dynamic>.from(updated);
      completedFreelancer = widget.freelancer;
      completedProject = widget.project;

      setState(() => settling = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(
            paymentData: updated,
            freelancer: widget.freelancer,
            project: widget.project,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => settling = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Settlement failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final smart = widget.paymentData['smartContract'] is Map
        ? Map<String, dynamic>.from(widget.paymentData['smartContract'] as Map)
        : <String, dynamic>{};

    final displayedContractId = _displaySmartValue(smart, [
      'contract_id',
      'contractId',
      'contractID',
      'id',
    ]);
    final displayedTransactionHash = _displaySmartValue(smart, [
      'transaction_hash',
      'transactionHash',
      'tx_hash',
      'txHash',
      'hash',
      'blockchain_tx_hash',
      'txHashHex',
    ]);
    final transactionHashForDisplay = displayedTransactionHash == '—'
        ? (displayedContractId == '—'
              ? '—'
              : _simulatedTransactionHash(
                  widget.paymentData['paymentId']?.toString() ?? 'payment',
                  displayedContractId,
                ))
        : displayedTransactionHash;

    return Scaffold(
      appBar: AppBar(title: const Text('Settlement')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                Container(
                  width: 85,
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Color(0xFF059669),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Settlement',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The payment is ready to execute after the smart contract is created.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _SettlementRow(title: 'Identity', status: 'Verified'),
                      _SettlementRow(title: 'Compliance', status: 'Passed'),
                      _SettlementRow(title: 'Fraud Check', status: 'Low Risk'),
                      _SettlementRow(title: 'FX Rate', status: 'Locked'),
                      _SettlementRow(
                        title: 'Smart Contract',
                        status: smart.isNotEmpty ? 'Created' : 'Missing',
                      ),
                    ],
                  ),
                ),
                if (smart.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      'Contract ID: $displayedContractId\n\nTransaction Hash: $transactionHashForDisplay\n\nNetwork: ${_displaySmartValue(smart, ['network', 'chain', 'network_name']) == '—' ? 'Polygon Amoy Testnet' : _displaySmartValue(smart, ['network', 'chain', 'network_name'])}',
                      style: const TextStyle(
                        color: Color(0xFF1E40AF),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFEA580C),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Blockchain and settlement execution are simulated in this hackathon prototype.',
                          style: TextStyle(
                            color: Color(0xFF9A3412),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton.icon(
                    onPressed: settling ? null : executeSettlement,
                    icon: settling
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.bolt_rounded),
                    label: Text(
                      settling
                          ? 'Executing Settlement...'
                          : 'EXECUTE SETTLEMENT',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettlementRow extends StatelessWidget {
  final String title;
  final String status;

  const _SettlementRow({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF059669)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(
            child: Text(
              status,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF059669),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SUCCESS
// ============================================================

class SuccessPage extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  final String freelancer;
  final String project;

  const SuccessPage({
    super.key,
    required this.paymentData,
    required this.freelancer,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final usd = paymentData['usdAmount'] as double;
    final inr = paymentData['inrAmount'] as double;
    final fxRate = paymentData['fxRate'] as double;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF059669),
                      size: 58,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Payment Successful!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your cross-border payment has been settled successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '\$${usd.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '₹${inr.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 12),
                        _InfoRow(
                          label: 'FX Rate',
                          value: '₹${fxRate.toStringAsFixed(2)} / USD',
                        ),
                        const _InfoRow(label: 'Client Fee', value: '\$0'),
                        const _InfoRow(label: 'Freelancer Fee', value: '₹0'),
                        const _InfoRow(label: 'FX Markup', value: '0%'),
                        const _InfoRow(label: 'Status', value: 'COMPLETED'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransactionDetailsPage(
                              paymentData: paymentData,
                              freelancer: freelancer,
                              project: project,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded),
                      label: const Text(
                        'View Transaction Details',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () => logout(context),
                    child: const Text('Back to FreezeX'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TRANSACTION DETAILS
// ============================================================

String _contractId(Map<String, dynamic> data) {
  final smart = data['smartContract'];
  if (smart is Map) {
    final map = Map<String, dynamic>.from(smart);
    for (final key in ['contract_id', 'contractId', 'contractID', 'id']) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty)
        return value.toString();
    }
  }
  return '—';
}

String _transactionHash(Map<String, dynamic> data) {
  final settlement = data['settlement'];
  final smart = data['smartContract'];
  for (final source in [settlement, smart]) {
    if (source is Map) {
      final map = Map<String, dynamic>.from(source);
      for (final key in [
        'transaction_hash',
        'transactionHash',
        'tx_hash',
        'txHash',
        'hash',
      ]) {
        final value = map[key];
        if (value != null && value.toString().trim().isNotEmpty)
          return value.toString();
      }
    }
  }
  return '—';
}

class TransactionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  final String freelancer;
  final String project;
  final bool returnToFreelancer;
  final String freelancerEmail;

  const TransactionDetailsPage({
    super.key,
    required this.paymentData,
    required this.freelancer,
    required this.project,
    this.returnToFreelancer = false,
    this.freelancerEmail = '',
  });

  @override
  Widget build(BuildContext context) {
    final usd = (paymentData['usdAmount'] as num?)?.toDouble() ?? 0.0;
    final inr = (paymentData['inrAmount'] as num?)?.toDouble() ?? 0.0;
    final fxRate = (paymentData['fxRate'] as num?)?.toDouble() ?? 0.0;

    String route = 'USA → INDIA';
    final routeValue = paymentData['route'];
    if (routeValue is Map) {
      final routeMap = Map<String, dynamic>.from(routeValue);
      final value = routeMap['route'];
      if (value != null && value.toString().trim().isNotEmpty) {
        route = value.toString();
      }
    } else if (routeValue != null && routeValue.toString().trim().isNotEmpty) {
      route = routeValue.toString();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(23),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        paymentData['paymentId']?.toString() ?? 'Transaction',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                _DetailSection(
                  title: 'Participants',
                  rows: [
                    ['Client', 'US Company'],
                    ['Freelancer', freelancer],
                    ['Project', project],
                  ],
                ),

                const SizedBox(height: 15),

                _DetailSection(
                  title: 'Payment',
                  rows: [
                    ['USD Amount', '\$${usd.toStringAsFixed(2)}'],
                    ['INR Payout', '₹${inr.toStringAsFixed(2)}'],
                    ['Locked FX Rate', '₹${fxRate.toStringAsFixed(2)} / USD'],
                    ['Client Fee', '\$0.00'],
                    ['Freelancer Fee', '₹0.00'],
                    ['FX Markup', '0%'],
                    ['Hidden Charges', '₹0.00'],
                  ],
                ),

                const SizedBox(height: 15),

                const _DetailSection(
                  title: 'Compliance',
                  rows: [
                    ['Identity', 'Verified'],
                    ['KYC', 'Passed'],
                    ['AML', 'Passed'],
                    ['Fraud Risk', 'Low'],
                  ],
                ),

                const SizedBox(height: 15),

                _PaymentTimeline(paymentData: paymentData),

                const SizedBox(height: 15),

                _DetailSection(
                  title: 'Settlement',
                  rows: [
                    ['Payment ID', paymentData['paymentId']?.toString() ?? '—'],
                    ['Route', route],
                    ['Smart Contract', 'Executed'],
                    ['Contract ID', _contractId(paymentData)],
                    ['Transaction Hash', _transactionHash(paymentData)],
                    ['Settlement', 'Completed'],
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => returnToFreelancer
                              ? FreelancerDashboard(
                                  userName: freelancer.isNotEmpty
                                      ? freelancer
                                      : 'Freelancer',
                                  email: freelancerEmail,
                                )
                              : ClientDashboard(
                                  clientId:
                                      (paymentData['clientId'] as num?)
                                          ?.toInt() ??
                                      1,
                                ),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentTimeline extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const _PaymentTimeline({required this.paymentData});

  bool _hasValue(dynamic value) {
    if (value == null) return false;
    final text = value.toString().trim();
    return text.isNotEmpty && text != '—' && text != 'null';
  }

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  bool _isCompleted() {
    final status = paymentData['status']?.toString().toUpperCase() ?? '';
    final settlement = _map(paymentData['settlement']);
    final settlementStatus =
        settlement['status']?.toString().toUpperCase() ?? '';
    return status.contains('COMPLETED') ||
        settlementStatus.contains('COMPLETED') ||
        settlementStatus.contains('SETTLED');
  }

  @override
  Widget build(BuildContext context) {
    final smart = _map(paymentData['smartContract']);
    final settlement = _map(paymentData['settlement']);
    final completed = _isCompleted();
    // A completed automatic payment has already passed the FX-lock and
    // smart-contract orchestration stages. History responses may omit the
    // nested FX/contract objects, so don't incorrectly show those stages
    // as pending after settlement is complete.
    final locked =
        completed ||
        paymentData['rateStatus']?.toString().toUpperCase() == 'LOCKED' ||
        _hasValue(paymentData['rateLockedAt']);
    final contractCreated =
        completed ||
        smart.isNotEmpty ||
        _hasValue(smart['contract_id']) ||
        _hasValue(smart['contractId']);
    final settled = completed || settlement.isNotEmpty || _isCompleted();

    final steps = <Map<String, dynamic>>[
      {
        'title': 'Payment Created',
        'subtitle': 'Payment request saved securely',
        'done': true,
        'icon': Icons.receipt_long_rounded,
      },
      {
        'title': 'Identity Verified',
        'subtitle': 'Participant identity check completed',
        'done': true,
        'icon': Icons.verified_user_rounded,
      },
      {
        'title': 'KYC / AML Passed',
        'subtitle': 'Compliance screening approved',
        'done': true,
        'icon': Icons.fact_check_rounded,
      },
      {
        'title': 'Fraud Check Passed',
        'subtitle': 'Risk assessment completed',
        'done': true,
        'icon': Icons.shield_rounded,
      },
      {
        'title': 'FX Rate Locked',
        'subtitle': locked
            ? 'Rate locked before settlement'
            : 'Waiting for FX lock',
        'done': locked,
        'icon': Icons.lock_clock_rounded,
      },
      {
        'title': 'Smart Contract Created',
        'subtitle': contractCreated
            ? 'Contract instruction created'
            : 'Waiting for contract creation',
        'done': contractCreated,
        'icon': Icons.account_tree_rounded,
      },
      {
        'title': 'Settlement Completed',
        'subtitle': settled
            ? 'Settlement instruction completed'
            : 'Waiting for settlement',
        'done': settled,
        'icon': Icons.account_balance_wallet_rounded,
      },
      {
        'title': 'Payment Complete',
        'subtitle': completed
            ? 'Funds successfully settled'
            : 'Final status pending',
        'done': completed,
        'icon': Icons.check_circle_rounded,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Timeline',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track every major step from payment creation to settlement.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 18),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final done = step['done'] as bool;
            final isLast = index == steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 34,
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: done
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: done
                                ? const Color(0xFF86EFAC)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        child: Icon(
                          done ? Icons.check_rounded : step['icon'] as IconData,
                          size: 17,
                          color: done
                              ? const Color(0xFF059669)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 38,
                          color: done
                              ? const Color(0xFFBBF7D0)
                              : const Color(0xFFE2E8F0),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: done
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          step['subtitle'] as String,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: Color(0xFFEA580C),
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Prototype notice: smart-contract and settlement execution are simulated for the hackathon.',
                    style: TextStyle(
                      color: Color(0xFF9A3412),
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<List<String>> rows;

  const _DetailSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 13),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row[0],
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      row[1],
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FREELANCER DASHBOARD
// ============================================================

class FreelancerDashboard extends StatefulWidget {
  final String userName;
  final String email;

  const FreelancerDashboard({
    super.key,
    this.userName = 'Freelancer',
    this.email = '',
  });

  @override
  State<FreelancerDashboard> createState() => _FreelancerDashboardState();
}

class _FreelancerDashboardState extends State<FreelancerDashboard> {
  Map<String, dynamic>? dashboard;
  bool loadingDashboard = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    if (widget.email.isEmpty) {
      if (mounted) setState(() => loadingDashboard = false);
      return;
    }
    try {
      final result = await ApiService.getFreelancerDashboard(widget.email);
      if (!mounted) return;
      setState(() {
        dashboard = result;
        loadingDashboard = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loadingDashboard = false);
    }
  }

  Future<void> openHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionHistoryPage(
          role: 'freelancer',
          freelancerEmail: widget.email,
        ),
      ),
    );
    loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final count = dashboard?['transaction_count']?.toString() ?? '0';
    final totalInr = dashboard?['total_inr'] is num
        ? (dashboard!['total_inr'] as num).toDouble()
        : double.tryParse('${dashboard?['total_inr'] ?? 0}') ?? 0;
    final pending = dashboard?['pending_count']?.toString() ?? '0';

    final payment = completedPayment;
    final hasPayment = payment != null;
    final recentInr = hasPayment
        ? ((payment!['inrAmount'] as num?)?.toDouble() ?? 0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FreezeX',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Transaction History',
            onPressed: openHistory,
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${widget.userName} 👋',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Freelancer Dashboard',
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Track your incoming international payments.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF047857)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Received / Available',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        totalInr > 0
                            ? '₹${totalInr.toStringAsFixed(2)}'
                            : '₹${recentInr.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'No freelancer transaction fee',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _DashboardStat(
                        title: 'Payments',
                        value: loadingDashboard ? '...' : count,
                        icon: Icons.payments_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DashboardStat(
                        title: 'Received INR',
                        value: loadingDashboard
                            ? '...'
                            : '₹${totalInr.toStringAsFixed(0)}',
                        icon: Icons.currency_rupee_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DashboardStat(
                        title: 'Pending',
                        value: loadingDashboard ? '...' : pending,
                        icon: Icons.schedule_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobSearchPage(
                          email: widget.email,
                          userName: widget.userName,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.search_rounded),
                    label: const Text(
                      'Search & Accept Jobs',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton.icon(
                    onPressed: openHistory,
                    icon: const Icon(Icons.history_rounded),
                    label: const Text(
                      'View Incoming Payments & History',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FreelancerWorkPage(email: widget.email),
                      ),
                    ),
                    icon: const Icon(Icons.task_alt_rounded),
                    label: const Text('My Accepted Jobs / Complete Work'),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Identity & KYC is already verified.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.badge_outlined),
                    label: const Text('View Identity & KYC'),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: TextButton.icon(
                    onPressed: () => logout(context),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TRANSACTION HISTORY
// ============================================================

class TransactionHistoryPage extends StatefulWidget {
  final String role;
  final int? clientId;
  final String? freelancerEmail;

  const TransactionHistoryPage({
    super.key,
    required this.role,
    this.clientId,
    this.freelancerEmail,
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  List<Map<String, dynamic>> transactions = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      List<Map<String, dynamic>> result;
      if (widget.role == 'client') {
        result = await ApiService.getClientPayments(widget.clientId!);
      } else {
        result = await ApiService.getFreelancerPayments(
          widget.freelancerEmail ?? '',
        );
      }

      // If the backend is temporarily empty but this session has a completed
      // payment, show it immediately instead of presenting a disabled/empty UI.
      if (result.isEmpty && completedPayment != null) {
        final local = Map<String, dynamic>.from(completedPayment!);
        local['freelancer_name'] ??= completedFreelancer ?? 'Freelancer';
        local['freelancer_email'] ??=
            completedPayment!['freelancerEmail'] ?? '';
        local['project'] ??= completedProject ?? 'International Project';
        local['status'] ??= 'COMPLETED';
        result = [local];
      }

      if (!mounted) return;
      setState(() {
        transactions = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  double _num(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0;
  }

  String _string(
    Map<String, dynamic> tx,
    List<String> keys, [
    String fallback = '—',
  ]) {
    for (final key in keys) {
      final value = tx[key];
      if (value != null && value.toString().trim().isNotEmpty)
        return value.toString();
    }
    return fallback;
  }

  Map<String, dynamic> _paymentData(Map<String, dynamic> tx) {
    final payment = tx['payment'] is Map
        ? Map<String, dynamic>.from(tx['payment'] as Map)
        : <String, dynamic>{};
    final fx = tx['fx'] is Map
        ? Map<String, dynamic>.from(tx['fx'] as Map)
        : <String, dynamic>{};
    final route = tx['route'] is Map
        ? Map<String, dynamic>.from(tx['route'] as Map)
        : <String, dynamic>{};
    final smart = tx['smart_contract'] is Map
        ? Map<String, dynamic>.from(tx['smart_contract'] as Map)
        : (tx['smartContract'] is Map
              ? Map<String, dynamic>.from(tx['smartContract'] as Map)
              : <String, dynamic>{});
    final settlement = tx['settlement'] is Map
        ? Map<String, dynamic>.from(tx['settlement'] as Map)
        : <String, dynamic>{};

    final usd = _num(
      payment['amount_usd'] ?? tx['amount_usd'] ?? tx['usdAmount'],
    );
    final inr = _num(
      payment['amount_inr'] ?? tx['amount_inr'] ?? tx['inrAmount'],
    );
    final rate = _num(
      fx['locked_rate'] ??
          fx['rate'] ??
          tx['locked_fx_rate'] ??
          tx['fx_rate'] ??
          tx['fxRate'],
    );

    return {
      'paymentId': _string(tx, ['payment_id', 'paymentId'], '—'),
      'clientId': tx['client_id'] ?? tx['clientId'],
      'usdAmount': usd,
      'inrAmount': inr,
      'fxRate': rate,
      'freelancerName': _string(tx, ['freelancer_name', 'freelancer']),
      'freelancerEmail': _string(tx, ['freelancer_email', 'email'], ''),
      'country': _string(tx, ['freelancer_country', 'country']),
      'project': _string(tx, ['project'], 'International Project'),
      'status': _string(tx, ['status'], 'UNKNOWN'),
      'route': route.isEmpty
          ? {
              'route': _string(tx, ['route'], 'USA → INDIA'),
            }
          : route,
      'smartContract': smart,
      'settlement': settlement,
      'rateStatus': _string(tx, ['rate_status', 'rateStatus'], 'AVAILABLE'),
      'rateLockedAt': tx['locked_fx_rate'] != null ? tx['updated_at'] : null,
    };
  }

  void openTransaction(Map<String, dynamic> tx) {
    final data = _paymentData(tx);
    final freelancer = _string(tx, [
      'freelancer_name',
      'freelancer',
    ], completedFreelancer ?? 'Freelancer');
    final project = _string(tx, [
      'project',
    ], completedProject ?? 'International Project');
    final email = _string(tx, [
      'freelancer_email',
      'email',
    ], widget.freelancerEmail ?? '');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionDetailsPage(
          paymentData: data,
          freelancer: freelancer,
          project: project,
          returnToFreelancer: widget.role == 'freelancer',
          freelancerEmail: email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.role == 'client'
        ? 'Transaction History'
        : 'Incoming Payments';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: loading ? null : loadHistory,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadHistory,
        child: loading
            ? ListView(
                children: [
                  SizedBox(height: 260),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : error != null
            ? ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  const SizedBox(height: 80),
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 55,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      'Could not load transaction history',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(child: Text(error!, textAlign: TextAlign.center)),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: loadHistory,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ],
              )
            : transactions.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  const SizedBox(height: 80),
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 60,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      widget.role == 'client'
                          ? 'No transactions yet'
                          : 'No incoming payments yet',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Completed and pending payments will appear here automatically.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final tx = transactions[index];
                  final payment = tx['payment'] is Map
                      ? Map<String, dynamic>.from(tx['payment'] as Map)
                      : <String, dynamic>{};
                  final usd = _num(
                    payment['amount_usd'] ??
                        tx['amount_usd'] ??
                        tx['usdAmount'],
                  );
                  final inr = _num(
                    payment['amount_inr'] ??
                        tx['amount_inr'] ??
                        tx['inrAmount'],
                  );
                  final name = _string(tx, [
                    'freelancer_name',
                    'freelancer',
                  ], completedFreelancer ?? 'Freelancer');
                  final project = _string(tx, [
                    'project',
                  ], completedProject ?? 'International Project');
                  final status = _string(tx, ['status'], 'UNKNOWN');

                  return Card(
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => openTransaction(tx),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: widget.role == 'client'
                                    ? const Color(0xFFEFF6FF)
                                    : const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                widget.role == 'client'
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                color: widget.role == 'client'
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.role == 'client'
                                        ? 'To $name'
                                        : 'From US Company',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _string(tx, [
                                      'payment_id',
                                      'paymentId',
                                    ], 'Payment'),
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${usd.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '₹${inr.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(0xFF059669),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        status.toUpperCase().contains('COMPLET')
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    status,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'FreezeX',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lock the rate. Move the money.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
            ),
            const SizedBox(height: 28),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PRIVACY POLICY
// ============================================================
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool accepted = false;

  Widget policySection(String title, String body, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void continueToRoles() {
    if (!accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please confirm that you have read the policy to continue.',
          ),
        ),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy & Platform Terms')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.privacy_tip_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                      SizedBox(height: 13),
                      Text(
                        'FreezeX Platform Policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Please review this policy before using the FreezeX prototype.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Effective for this hackathon prototype',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                policySection(
                  '1. What FreezeX Provides',
                  'FreezeX is a digital marketplace and payment-orchestration prototype connecting clients and freelancers. It demonstrates project discovery, identity/compliance checks, FX conversion, rate locking and automated payment orchestration.',
                  Icons.hub_outlined,
                ),
                policySection(
                  '2. Information We Collect',
                  'The prototype may collect account and profile information such as name, email, phone number, country, company details, professional skills, experience, project information and transaction-related data. Information is used only for the workflows demonstrated by the platform.',
                  Icons.folder_shared_outlined,
                ),
                policySection(
                  '3. How Information Is Used',
                  'Information may be processed for account management, freelancer/client matching, project coordination, identity verification, KYC/AML screening, fraud-prevention logic, FX and payment orchestration, transaction records and platform administration.',
                  Icons.manage_accounts_outlined,
                ),
                policySection(
                  '4. Client–Freelancer Responsibility',
                  'Clients and freelancers are responsible for the accuracy of their project descriptions, deliverables, deadlines, quality expectations, intellectual-property arrangements and other contractual matters. FreezeX provides marketplace and payment-orchestration functionality and does not guarantee the quality, legality, ownership, accuracy or successful completion of work exchanged between participants.',
                  Icons.handshake_outlined,
                ),
                policySection(
                  '5. Disputes',
                  'Disputes concerning project scope, quality, deadlines, deliverables, intellectual property or contractual obligations should be addressed between the client and freelancer under their agreed terms. FreezeX is not the contracting party for the underlying freelance work. Any payment or platform intervention is subject to the applicable platform rules and available processes.',
                  Icons.gavel_outlined,
                ),
                policySection(
                  '6. Compliance & Security',
                  'The prototype demonstrates rule-based identity, KYC/AML and fraud checks. Production deployment would require appropriate security controls, data-protection measures, regulated financial/payment partners and compliance with applicable laws, including relevant Indian and international requirements.',
                  Icons.security_outlined,
                ),
                policySection(
                  '7. Cross-Border Data & Privacy',
                  'Because FreezeX is designed for cross-border workflows, information may need to be processed across jurisdictions in a production environment. Production implementation would apply appropriate privacy, security, retention and data-transfer safeguards required by applicable law.',
                  Icons.public_outlined,
                ),
                policySection(
                  '8. Prototype / Simulation Notice',
                  'This hackathon prototype simulates certain KYC/AML, decentralized-identity, smart-contract, blockchain and settlement operations. A production version would require real regulated infrastructure, deployed contracts where appropriate, secure wallet/payment integrations, operational controls and legal review.',
                  Icons.science_outlined,
                ),
                policySection(
                  '9. No Guarantee of Availability',
                  'Prototype services may be changed, interrupted or unavailable during development and demonstration. The prototype should not be treated as a live financial service or as a substitute for regulated financial advice.',
                  Icons.info_outline_rounded,
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: CheckboxListTile(
                    value: accepted,
                    onChanged: (value) =>
                        setState(() => accepted = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'I have read and understand the Privacy Policy & Platform Terms.',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: const Text(
                      'This confirmation is part of the prototype onboarding flow.',
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: continueToRoles,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text(
                      'I Understand & Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'FreezeX • Lock the rate. Move the money.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ADMIN
// ============================================================
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final email = TextEditingController(text: 'admin@freezex.com');
  final password = TextEditingController(text: 'Admin@123');
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);
    try {
      await ApiService.adminLogin(
        email: email.text.trim(),
        password: password.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
      );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Access')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 60,
                      color: Color(0xFF7C3AED),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'FreezeX Admin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(
                        labelText: 'Admin Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: loading ? null : login,
                        child: Text(loading ? 'Signing in...' : 'Admin Login'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Demo admin access for the hackathon prototype.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  Map<String, dynamic>? overview;
  List<Map<String, dynamic>> subscriptions = [];
  List<Map<String, dynamic>> clients = [];
  List<Map<String, dynamic>> freelancers = [];
  List<Map<String, dynamic>> projects = [];
  List<Map<String, dynamic>> payments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final results = await Future.wait([
        ApiService.getAdminOverview(),
        ApiService.getAdminSubscriptions(),
        ApiService.getAdminClients(),
        ApiService.getAdminFreelancers(),
        ApiService.getAdminProjects(),
        ApiService.getAdminPayments(),
      ]);
      if (!mounted) return;
      setState(() {
        overview = results[0] as Map<String, dynamic>;
        subscriptions = results[1] as List<Map<String, dynamic>>;
        clients = results[2] as List<Map<String, dynamic>>;
        freelancers = results[3] as List<Map<String, dynamic>>;
        projects = results[4] as List<Map<String, dynamic>>;
        payments = results[5] as List<Map<String, dynamic>>;
        loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> changeSubscription(int id, String status) async {
    try {
      await ApiService.updateAdminSubscription(
        subscriptionId: id,
        status: status,
      );
      await load();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Widget stat(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF7C3AED)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = overview ?? <String, dynamic>{};
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreezeX Admin Dashboard'),
        actions: [
          IconButton(onPressed: load, icon: const Icon(Icons.refresh_rounded)),
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Platform Control Center',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Admin manages clients, freelancers, subscriptions, projects and payments.',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                stat('Clients', '${o['clients'] ?? 0}', Icons.business_rounded),
                const SizedBox(width: 10),
                stat(
                  'Freelancers',
                  '${o['freelancers'] ?? 0}',
                  Icons.person_rounded,
                ),
                const SizedBox(width: 10),
                stat(
                  'Subscriptions',
                  '${o['subscriptions'] ?? 0}',
                  Icons.workspace_premium_rounded,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                stat(
                  'Projects',
                  '${o['projects'] ?? 0}',
                  Icons.work_outline_rounded,
                ),
                const SizedBox(width: 10),
                stat(
                  'Payments',
                  '${o['payments'] ?? 0}',
                  Icons.payments_rounded,
                ),
                const SizedBox(width: 10),
                stat(
                  'Completed',
                  '${o['completed_payments'] ?? 0}',
                  Icons.check_circle_rounded,
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Text(
              'Subscription Management',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            if (loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (!loading && subscriptions.isEmpty)
              const Text('No subscriptions yet.'),
            ...subscriptions.map((s) {
              final id = (s['id'] as num).toInt();
              final status = s['status'].toString();
              return Card(
                elevation: 0,
                child: ListTile(
                  title: Text('${s['client_name']} • ${s['plan']}'),
                  subtitle: Text('${s['email']} • \$${s['amount']} • $status'),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      if (status != 'ACTIVE')
                        TextButton(
                          onPressed: () => changeSubscription(id, 'ACTIVE'),
                          child: const Text('Activate'),
                        ),
                      if (status == 'ACTIVE')
                        TextButton(
                          onPressed: () => changeSubscription(id, 'SUSPENDED'),
                          child: const Text('Suspend'),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 18),
            _AdminListSection(
              title: 'Clients',
              count: clients.length,
              children: clients
                  .map(
                    (c) => ListTile(
                      leading: const Icon(Icons.business_outlined),
                      title: Text(c['name'].toString()),
                      subtitle: Text(
                        '${c['email']} • Subscription: ${c['subscription']}',
                      ),
                    ),
                  )
                  .toList(),
            ),
            _AdminListSection(
              title: 'Freelancers',
              count: freelancers.length,
              children: freelancers
                  .map(
                    (f) => ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(f['name'].toString()),
                      subtitle: Text(
                        '${f['email']} • ${f['skills']} • ${f['experience']}',
                      ),
                    ),
                  )
                  .toList(),
            ),
            _AdminListSection(
              title: 'Projects',
              count: projects.length,
              children: projects
                  .map(
                    (p) => ListTile(
                      leading: const Icon(Icons.work_outline),
                      title: Text(p['title'].toString()),
                      subtitle: Text(
                        '\$${p['budget_usd']} • ${p['status']} • ${p['freelancer_email'] ?? ''}',
                      ),
                    ),
                  )
                  .toList(),
            ),
            _AdminListSection(
              title: 'Payments',
              count: payments.length,
              children: payments
                  .take(10)
                  .map(
                    (p) => ListTile(
                      leading: const Icon(Icons.payments_outlined),
                      title: Text(p['payment_id'].toString()),
                      subtitle: Text('${p['project']} • ${p['status']}'),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminListSection extends StatelessWidget {
  final String title;
  final int count;
  final List<Widget> children;
  const _AdminListSection({
    required this.title,
    required this.count,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ExpansionTile(
        title: Text(
          '$title ($count)',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        children: children,
      ),
    );
  }
}

// ============================================================
// CLIENT PROJECT POSTING
// ============================================================
class ProjectPostPage extends StatefulWidget {
  final int clientId;
  const ProjectPostPage({super.key, required this.clientId});
  @override
  State<ProjectPostPage> createState() => _ProjectPostPageState();
}

class _ProjectPostPageState extends State<ProjectPostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final skillsController = TextEditingController();
  final budgetController = TextEditingController(text: '500');
  final deadlineController = TextEditingController(text: '7 days');
  List<Map<String, dynamic>> projects = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      final result = await ApiService.getClientProjects(widget.clientId);
      if (mounted) setState(() => projects = result);
    } catch (_) {}
  }

  Future<void> postProject() async {
    final budget = double.tryParse(budgetController.text.trim()) ?? 0;
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter project title, description and a valid budget.'),
        ),
      );
      return;
    }
    setState(() => loading = true);
    try {
      await ApiService.createProject(
        clientId: widget.clientId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        skills: skillsController.text.trim(),
        budgetUsd: budget,
        deadline: deadlineController.text.trim(),
      );
      titleController.clear();
      descriptionController.clear();
      skillsController.clear();
      await loadProjects();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your project has been posted successfully.'),
          ),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Post Your Requirement',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Describe the work you need and let freelancers find it.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Project Description / Requirements',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: skillsController,
                  decoration: const InputDecoration(
                    labelText: 'Required Skills',
                    hintText: 'Flutter, Dart, REST API',
                    prefixIcon: Icon(Icons.code_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: budgetController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Budget (USD)',
                          prefixText: '\$ ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: deadlineController,
                        decoration: const InputDecoration(
                          labelText: 'Deadline',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: loading ? null : postProject,
                    icon: const Icon(Icons.publish_rounded),
                    label: Text(loading ? 'Posting...' : 'Post Requirement'),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'My Posted Projects',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                ...projects.map(
                  (p) => Card(
                    elevation: 0,
                    child: ListTile(
                      title: Text(p['title'].toString()),
                      subtitle: Text(
                        '\$${p['budget_usd']} • ${p['status']} • ${p['freelancer_email'] ?? ''}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FREELANCER JOB SEARCH
// ============================================================
class JobSearchPage extends StatefulWidget {
  final String email;
  final String userName;
  const JobSearchPage({super.key, required this.email, required this.userName});
  @override
  State<JobSearchPage> createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  List<Map<String, dynamic>> jobs = [];
  bool loading = true;
  String query = '';

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      final result = await ApiService.getProjects();
      if (mounted)
        setState(() {
          jobs = result;
          loading = false;
        });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> acceptJob(Map<String, dynamic> project) async {
    try {
      await ApiService.acceptProject(
        projectId: (project['id'] as num).toInt(),
        freelancerEmail: widget.email,
      );
      await loadJobs();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job accepted. Work can now begin.')),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = jobs.where((p) {
      final q = query.toLowerCase();
      return q.isEmpty ||
          p['title'].toString().toLowerCase().contains(q) ||
          p['skills'].toString().toLowerCase().contains(q) ||
          p['description'].toString().toLowerCase().contains(q);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Jobs'),
        actions: [
          IconButton(
            onPressed: loadJobs,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                labelText: 'Search by project, skill or requirement',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? const Center(child: Text('No matching jobs found.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final p = filtered[index];
                      return Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      p['title'].toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${p['budget_usd']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p['description'].toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Skills: ${p['skills']} • Deadline: ${p['deadline']}',
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: FilledButton.icon(
                                  onPressed: () => acceptJob(p),
                                  icon: const Icon(Icons.handshake_rounded),
                                  label: const Text('Accept Job'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FREELANCER WORK COMPLETION
// ============================================================
class FreelancerWorkPage extends StatefulWidget {
  final String email;
  const FreelancerWorkPage({super.key, required this.email});
  @override
  State<FreelancerWorkPage> createState() => _FreelancerWorkPageState();
}

class _FreelancerWorkPageState extends State<FreelancerWorkPage> {
  List<Map<String, dynamic>> projects = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      final result = await ApiService.getFreelancerProjects(widget.email);
      if (mounted)
        setState(() {
          projects = result;
          loading = false;
        });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> completeWork(Map<String, dynamic> project) async {
    try {
      final result = await ApiService.completeProject(
        projectId: (project['id'] as num).toInt(),
        freelancerEmail: widget.email,
      );
      await loadProjects();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Work completed. Automatic payment has been triggered.',
            ),
          ),
        );
        if (result['payment'] is Map) {
          completedPayment = Map<String, dynamic>.from(result['payment']);
          completedFreelancer = widget.email;
          completedProject = project['title'].toString();
        }
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (projects.isEmpty)
      return Scaffold(
        appBar: AppBar(title: const Text('My Accepted Jobs')),
        body: const Center(child: Text('No accepted jobs yet.')),
      );
    return Scaffold(
      appBar: AppBar(title: const Text('My Accepted Jobs')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: projects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final p = projects[index];
          final completed = p['status'] == 'COMPLETED';
          return Card(
            elevation: 0,
            child: ListTile(
              title: Text(
                p['title'].toString(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('\$${p['budget_usd']} • ${p['status']}'),
              trailing: completed
                  ? const Icon(Icons.check_circle, color: Color(0xFF059669))
                  : FilledButton(
                      onPressed: () => completeWork(p),
                      child: const Text('Complete'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
