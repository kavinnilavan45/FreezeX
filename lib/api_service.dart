import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8001';

  static Future<Map<String, dynamic>> getLiveFxRate() async {
    final response = await http.get(
      Uri.parse('$baseUrl/fx/usd-inr'),
      headers: {'Accept': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'FX rate service failed');
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role.toLowerCase(),
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Login failed');
  }

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    String country = '',
    String phone = '',
    String companyName = '',
    String companyType = '',
    String businessDescription = '',
    String skills = '',
    String experience = '',
    String about = '',
    String lookingFor = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role.toLowerCase(),
        'country': country,
        'phone': phone,
        'company_name': companyName,
        'company_type': companyType,
        'business_description': businessDescription,
        'skills': skills,
        'experience': experience,
        'about': about,
        'looking_for': lookingFor,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Account creation failed');
  }

  static Future<Map<String, dynamic>> createPayment({
    required int clientId,
    required String freelancerName,
    required String freelancerEmail,
    required String country,
    required double amountUsd,
    required String project,
    bool identityVerified = true,
    String walletAddress = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': clientId,
        'freelancer_name': freelancerName,
        'freelancer_email': freelancerEmail,
        'country': country,
        'amount_usd': amountUsd,
        'project': project,
        'identity_verified': identityVerified,
        'wallet_address': walletAddress,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Payment creation failed');
  }

  static Future<Map<String, dynamic>> lockFxRate({
    required String paymentId,
    required double amountUsd,
    required double fxRate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/$paymentId/lock-rate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount_usd': amountUsd,
        'fx_rate': fxRate,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'FX rate lock failed');
  }

  static Future<Map<String, dynamic>> createSmartContract({
    required String paymentId,
    required double amountUsd,
    required double amountInr,
    required double fxRate,
    required String freelancerName,
    required String freelancerEmail,
    required String project,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/$paymentId/smart-contract'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount_usd': amountUsd,
        'amount_inr': amountInr,
        'fx_rate': fxRate,
        'freelancer_name': freelancerName,
        'freelancer_email': freelancerEmail,
        'project': project,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Smart contract creation failed');
  }

  static Future<Map<String, dynamic>> settlePayment({
    required String paymentId,
    required double amountUsd,
    required double amountInr,
    required double fxRate,
    required String contractId,
    required String transactionHash,
    required String freelancerName,
    required String freelancerEmail,
    required String project,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/$paymentId/settle'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount_usd': amountUsd,
        'amount_inr': amountInr,
        'fx_rate': fxRate,
        'contract_id': contractId,
        'transaction_hash': transactionHash,
        'freelancer_name': freelancerName,
        'freelancer_email': freelancerEmail,
        'project': project,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Settlement failed');
  }

  static Future<Map<String, dynamic>> getPaymentStatus(
    String paymentId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/$paymentId/status'),
      headers: {'Accept': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not get payment status');
  }
  static Future<List<Map<String, dynamic>>> getClientPayments(int clientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/client/$clientId'),
      headers: {'Accept': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final list = data is List ? data : (data['transactions'] ?? data['payments'] ?? []);
      return List<Map<String, dynamic>>.from(
        (list as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
      );
    }
    throw Exception(data is Map ? (data['detail'] ?? 'Could not load client payments') : 'Could not load client payments');
  }

  static Future<List<Map<String, dynamic>>> getFreelancerPayments(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/freelancer/${Uri.encodeComponent(email)}'),
      headers: {'Accept': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final list = data is List ? data : (data['transactions'] ?? data['payments'] ?? []);
      return List<Map<String, dynamic>>.from(
        (list as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
      );
    }
    throw Exception(data is Map ? (data['detail'] ?? 'Could not load freelancer payments') : 'Could not load freelancer payments');
  }

  static Future<Map<String, dynamic>> getClientDashboard(int clientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/client/$clientId'),
      headers: {'Accept': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data is Map ? (data['detail'] ?? 'Could not load client dashboard') : 'Could not load client dashboard');
  }

  static Future<Map<String, dynamic>> getFreelancerDashboard(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/freelancer/${Uri.encodeComponent(email)}'),
      headers: {'Accept': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data is Map ? (data['detail'] ?? 'Could not load freelancer dashboard') : 'Could not load freelancer dashboard');
  }

  static Future<Map<String, dynamic>> getPayment(String paymentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/$paymentId'),
      headers: {'Accept': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data is Map ? (data['detail'] ?? 'Could not load payment') : 'Could not load payment');
  }


  static Future<Map<String, dynamic>> adminLogin({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Admin login failed');
  }

  static Future<Map<String, dynamic>> getAdminOverview() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/overview'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not load admin overview');
  }

  static Future<List<Map<String, dynamic>>> getAdminSubscriptions() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/subscriptions'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['subscriptions'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load subscriptions');
  }

  static Future<Map<String, dynamic>> updateAdminSubscription({required int subscriptionId, required String status}) async {
    final response = await http.put(Uri.parse('$baseUrl/admin/subscriptions/$subscriptionId'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'status': status}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not update subscription');
  }

  static Future<List<Map<String, dynamic>>> getAdminClients() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/clients'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['clients'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load clients');
  }

  static Future<Map<String, dynamic>> updateAdminUserStatus({required int userId, required String status}) async {
    final response = await http.put(Uri.parse('$baseUrl/admin/users/$userId/status'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'status': status}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not update account status');
  }

  static Future<List<Map<String, dynamic>>> getAdminFreelancers() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/freelancers'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['freelancers'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load freelancers');
  }

  static Future<List<Map<String, dynamic>>> getAdminProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/projects'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['projects'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load projects');
  }

  static Future<List<Map<String, dynamic>>> getAdminPayments() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/payments'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['payments'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load payments');
  }

  static Future<Map<String, dynamic>> createProject({required int clientId, required String title, required String description, required String skills, required double budgetUsd, required String deadline}) async {
    final response = await http.post(Uri.parse('$baseUrl/projects'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'client_id': clientId, 'title': title, 'description': description, 'skills': skills, 'budget_usd': budgetUsd, 'deadline': deadline}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not post project');
  }

  static Future<List<Map<String, dynamic>>> getProjects({String status = 'POSTED'}) async {
    final response = await http.get(Uri.parse('$baseUrl/projects?status=$status'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['projects'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load projects');
  }

  static Future<List<Map<String, dynamic>>> getClientProjects(int clientId) async {
    final response = await http.get(Uri.parse('$baseUrl/projects/client/$clientId'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['projects'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load client projects');
  }

  static Future<List<Map<String, dynamic>>> getFreelancerProjects(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/projects/freelancer/${Uri.encodeComponent(email)}'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from((data['projects'] as List).map((e) => Map<String, dynamic>.from(e)));
    throw Exception(data['detail'] ?? 'Could not load freelancer projects');
  }

  static Future<Map<String, dynamic>> acceptProject({required int projectId, required String freelancerEmail}) async {
    final response = await http.post(Uri.parse('$baseUrl/projects/$projectId/accept'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'freelancer_email': freelancerEmail}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not accept project');
  }

  static Future<Map<String, dynamic>> applyProject({required int projectId, required String freelancerEmail}) async {
    final response = await http.post(Uri.parse('$baseUrl/projects/$projectId/apply'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'freelancer_email': freelancerEmail}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not apply to project');
  }

  static Future<Map<String, dynamic>> completeProject({required int projectId, required String freelancerEmail}) async {
    final response = await http.post(Uri.parse('$baseUrl/projects/$projectId/complete'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'freelancer_email': freelancerEmail}));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return Map<String, dynamic>.from(data);
    throw Exception(data['detail'] ?? 'Could not complete project');
  }

}
