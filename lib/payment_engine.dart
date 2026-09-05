class PaymentEngine {
  static const double usdToInrRate = 83.50;

  static double convertUsdToInr(double usd) {
    return usd * usdToInrRate;
  }

  static Map<String, dynamic> complianceCheck({
    required bool identityVerified,
    required bool kycPassed,
    required bool amlPassed,
  }) {
    final approved = identityVerified && kycPassed && amlPassed;

    return {
      'identity': identityVerified,
      'kyc': kycPassed,
      'aml': amlPassed,
      'approved': approved,
      'status': approved ? 'APPROVED' : 'REVIEW REQUIRED',
    };
  }

  static Map<String, dynamic> fraudCheck({
    required double amount,
    required bool identityVerified,
    required bool kycPassed,
    required bool amlPassed,
  }) {
    int score = 0;

    if (!identityVerified) score += 25;
    if (!kycPassed) score += 25;
    if (!amlPassed) score += 30;

    if (amount >= 10000) {
      score += 15;
    } else if (amount >= 5000) {
      score += 8;
    }

    String decision;

    if (score > 70) {
      decision = 'BLOCK';
    } else if (score > 30) {
      decision = 'REVIEW';
    } else {
      decision = 'APPROVE';
    }

    return {
      'score': score,
      'decision': decision,
      'approved': decision == 'APPROVE',
    };
  }

  static Map<String, dynamic> findBestRoute() {
    final routes = <Map<String, dynamic>>[
      {'route': 'USA → USDC → INDIA', 'fee': 4.20, 'time': 3.0, 'risk': 6.5},
      {'route': 'USA → UAE → INDIA', 'fee': 10.40, 'time': 10.0, 'risk': 8.0},
      {'route': 'USA → INDIA', 'fee': 18.00, 'time': 2880.0, 'risk': 10.0},
    ];

    routes.sort((a, b) {
      final feeA = a['fee'] as double;
      final timeA = a['time'] as double;
      final riskA = a['risk'] as double;

      final feeB = b['fee'] as double;
      final timeB = b['time'] as double;
      final riskB = b['risk'] as double;

      final scoreA = feeA * 5 + timeA * 0.01 + riskA * 2;

      final scoreB = feeB * 5 + timeB * 0.01 + riskB * 2;

      return scoreA.compareTo(scoreB);
    });

    return routes.first;
  }

  static Map<String, dynamic> processPayment({required double usdAmount}) {
    final inrAmount = convertUsdToInr(usdAmount);

    final compliance = complianceCheck(
      identityVerified: true,
      kycPassed: true,
      amlPassed: true,
    );

    final fraud = fraudCheck(
      amount: usdAmount,
      identityVerified: true,
      kycPassed: true,
      amlPassed: true,
    );

    final route = findBestRoute();

    return {
      'usdAmount': usdAmount,
      'inrAmount': inrAmount,
      'fxRate': usdToInrRate,
      'clientFee': 0.0,
      'freelancerFee': 0.0,
      'fxMarkup': 0.0,
      'hiddenCharges': 0.0,
      'compliance': compliance,
      'fraud': fraud,
      'route': route,
      'status': 'READY FOR SETTLEMENT',
    };
  }
}
