import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    List<ProductElement> product;

    Product({
        required this.product,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        product: List<ProductElement>.from(json["product"].map((x) => ProductElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "product": List<dynamic>.from(product.map((x) => x.toJson())),
    };
}

class ProductElement {
    double productPrice;
    int id;
    String productName;
    String imgUrl;
    String productDetails;
    String productType;

    ProductElement({
        required this.productPrice,
        required this.id,
        required this.productName,
        required this.imgUrl,
        required this.productDetails,
        required this.productType,
    });

    factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        productPrice: json["product_price"],
        id: json["id"],
        productName: json["product_name"],
        imgUrl: json["img_url"],
        productDetails: json["product_details"],
        productType: json["product_type"],
    );

    Map<String, dynamic> toJson() => {
        "product_price": productPrice,
        "id": id,
        "product_name": productName,
        "img_url": imgUrl,
        "product_details": productDetails,
        "product_type": productType,
    };
}
