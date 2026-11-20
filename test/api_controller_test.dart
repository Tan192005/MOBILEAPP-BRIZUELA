import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/course_model.dart';
import 'package:flutter_application_1/services/api_controller.dart';
import 'package:http/http.dart' as http;

class _FakeHttpClient extends http.BaseClient {
  _FakeHttpClient(this.response);

  final http.Response response;
  Uri? requestedUri;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUri = request.url;
    return http.StreamedResponse(
      Stream.value(utf8.encode(response.body)),
      response.statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  test('Course maps a product from the catalog API', () {
    final course = Course.fromJson({
      'id': 42,
      'title': 'Training Mat',
      'description': 'A non-slip exercise mat.',
      'price': 19.5,
      'category': 'sports-accessories',
      'thumbnail': 'https://example.com/mat.jpg',
    });

    expect(course.name, 'Training Mat');
    expect(course.content, 'A non-slip exercise mat.');
    expect(course.cost, 19.5);
    expect(course.category, 'sports-accessories');
    expect(course.image, 'https://example.com/mat.jpg');
  });

  test(
    'fetchProducts requests the API and maps its JSON product array',
    () async {
      final client = _FakeHttpClient(
        http.Response(
          jsonEncode({
            'products': [
              {
                'id': 42,
                'title': 'Training Mat',
                'description': 'A non-slip exercise mat.',
                'price': 19.5,
                'category': 'sports-accessories',
                'thumbnail': 'https://example.com/mat.jpg',
              },
              {
                'id': 43,
                'title': 'Mascara',
                'description': 'Cosmetic product.',
                'price': 9.99,
                'category': 'beauty',
                'thumbnail': 'https://example.com/mascara.jpg',
              },
            ],
          }),
          200,
        ),
      );
      final controller = ApiController(client: client);
      addTearDown(client.close);

      final products = await controller.fetchProducts();

      expect(client.requestedUri, ApiController.productsUri);
      expect(
        client.requestedUri!.path,
        '/products/category/sports-accessories',
      );
      expect(products, hasLength(1));
      expect(products.single.id, 42);
      expect(products.single.title, 'Training Mat');
      expect(products.single.price, 19.5);
      expect(products.single.category, 'sports-accessories');
      expect(products.single.thumbnail, 'https://example.com/mat.jpg');
    },
  );

  test('fetchProducts reports unsuccessful API responses', () async {
    final client = _FakeHttpClient(http.Response('Unavailable', 503));
    final controller = ApiController(client: client);
    addTearDown(client.close);

    await expectLater(controller.fetchProducts(), throwsException);
  });

  test('fetchProducts rejects responses without a products array', () async {
    final client = _FakeHttpClient(http.Response('{"items":[]}', 200));
    final controller = ApiController(client: client);
    addTearDown(client.close);

    await expectLater(controller.fetchProducts(), throwsFormatException);
  });
}
