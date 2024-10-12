abstract class ApiConfig {
  static const String baseUrl = '';
}

class GisaApiConfig extends ApiConfig {
  // static const String baseUrl = 'http://192.168.0.119:8000/api';
  // static const String baseUrl = 'http://192.168.1.7:8000/api';
  static const String baseUrl = 'https://ss.gisagroup.id/api';

  static const String login = '$baseUrl/login';

  static const String salesSummary = '$baseUrl/sales/summary';

  static const String productSold = '$baseUrl/sales/product-sold';

  static const String orders = '$baseUrl/sales/orders';

  static const String topSalesman = '$baseUrl/sales/top-salesman';

  static const String salesman = '$baseUrl/sales/detail-salesman';

  static const String stock = '$baseUrl/inventory/stock';

  static const String stockAttention = '$baseUrl/inventory/attention-stock';
}
