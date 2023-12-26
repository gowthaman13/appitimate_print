// class PrintDetail {
//   // late String action;
//   late PrintData data;

//   PrintDetail.fromJson(Map<String, dynamic> json) {
//     // action = json['action'];
//     data = PrintData.fromJson(json['data']);
//   }
// }

// class PrintData {
//   // late Department department;
//   late String billNo;
//   late String date;
//   late String time;
//   late String cashier;
//   late double grossTotal;
//   late double totalDiscount;
//   late double totalPaid;
//   late String companyLogo;
//   late String logo;
//   // late Customer customer;
//   // late List<Product> products;

//   PrintData.fromJson(Map<dynamic, dynamic> json) {
//     // department = Department.fromJson(json['department']);
//     billNo = json['bill_no'];
//     date = json['date'];
//     time = json['time'];
//     cashier = json['cashier'];
//     grossTotal = double.parse(json['gross_total']);
//     totalDiscount = double.parse(json['total_discount']);
//     totalPaid = double.parse(json['total_paid']);
//     companyLogo = json['company_logo'];
//     logo = json['logo'];
//     // customer = Customer.fromJson(json['customer']);
//     // products = List<Product>.from(
//     //     json['products'].map((product) => Product.fromJson(product)));
//   }
// }

// // class Department {
// //   late int id;
// //   late String name;
// //   late String barcodeDepartmentName;
// //   late String email;
// //   late String thankMsg;
// //   late double latitude;
// //   late double longitude;
// //   late String updatedAt;
// //   late String logo;

// //   Department.fromJson(Map<dynamic, dynamic> json) {
// //     id = json['id'];
// //     name = json['name'];
// //     barcodeDepartmentName = json['barcode_department_name'];
// //     email = json['email'];
// //     thankMsg = json['thank_msg'];
// //     latitude = json['latitude'];
// //     longitude = json['longitude'];
// //     updatedAt = json['updated_at'];
// //     logo = json['logo'];
// //   }
// // }

// // class Customer {
// //   late String name;
// //   late String code;

// //   Customer.fromJson(Map<dynamic, dynamic> json) {
// //     name = json['name'];
// //     code = json['code'];
// //   }
// // }

// // class Product {
// //   late int id;
// //   late String code;
// //   late String label;
// //   late double unitPrice;
// //   late double qty;
// //   late double discount;
// //   late double total;

// //   Product.fromJson(Map<dynamic, dynamic> json) {
// //     id = json['id'];
// //     code = json['code'];
// //     label = json['label'];
// //     unitPrice = json['unit_price'];
// //     qty = json['qty'];
// //     discount = json['discount'];
// //     total = json['total'];
// //   }
// // }

// // class PrintDetail {
// //   late String action;
// //   late PrintData data;

// //   PrintDetail.fromJson(Map<String, dynamic> json) {
// //     action = json['action']!;
// //     data = PrintData.fromJson(json['data']!);
// //   }
// // }

// // class PrintData {
// //   late Department department;
// //   late String billNo;
// //   late String date;
// //   late String time;
// //   late String cashier;
// //   late String grossTotal;
// //   late String totalDiscount;
// //   late String totalPaid;
// //   late String companyLogo;
// //   late Customer customer;
// //   late List<Product> products;

// //   PrintData.fromJson(Map<String, dynamic> json) {
// //     department = Department.fromJson(json['department']!);
// //     billNo = json['bill_no']!;
// //     date = json['date']!;
// //     time = json['time']!;
// //     cashier = json['cashier']!;
// //     grossTotal = json['gross_total']!;
// //     totalDiscount = json['total_discount']!;
// //     totalPaid = json['total_paid']!;
// //     companyLogo = json['company_logo']!;
// //     customer = Customer.fromJson(json['customer']!);
// //     products = List<Product>.from(
// //         json['products']!.map((product) => Product.fromJson(product)));
// //   }
// // }

// // class Department {
// //   late String id;
// //   late String name;
// //   late String barcodeDepartmentName;
// //   late String email;
// //   late String thankMsg;
// //   late String latitude;
// //   late String longitude;
// //   late String updatedAt;
// //   late String logo;

// //   Department.fromJson(Map<String, dynamic> json) {
// //     id = json['id']!;
// //     name = json['name']!;
// //     barcodeDepartmentName = json['barcode_department_name']!;
// //     email = json['email']!;
// //     thankMsg = json['thank_msg']!;
// //     latitude = json['latitude']!;
// //     longitude = json['longitude']!;
// //     updatedAt = json['updated_at']!;
// //     logo = json['logo']!;
// //   }
// // }

// // class Customer {
// //   late String name;
// //   late String code;

// //   Customer.fromJson(Map<String, dynamic> json) {
// //     name = json['name']!;
// //     code = json['code']!;
// //   }
// // }

// // class Product {
// //   late String id;
// //   late String code;
// //   late String label;
// //   late String unitPrice;
// //   late String qty;
// //   late String discount;
// //   late String total;

// //   Product.fromJson(Map<String, dynamic> json) {
// //     id = json['id']!;
// //     code = json['code']!;
// //     label = json['label']!;
// //     unitPrice = json['unit_price']!;
// //     qty = json['qty']!;
// //     discount = json['discount']!;
// //     total = json['total']!;
// //   }
// // }
class PrintDetail {
  String action;
  Data data;

  PrintDetail({required this.action, required this.data});

  factory PrintDetail.fromJson(Map<String, dynamic> json) {
    return PrintDetail(
      action: json['action'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}

class Data {
  Department department;
  String billNo;
  String date;
  String time;
  String cashier;
  String total;
  String totalDiscount;
  String deliveryCharge;
  String otherCharge;
  String packageCharge;
  String serviceCharge;
  String totalPaid;
  String companyLogo;
  Customer customer;
  List<Product> products;

  Data({
    required this.department,
    required this.billNo,
    required this.date,
    required this.time,
    required this.cashier,
    required this.total,
    required this.totalDiscount,
    required this.totalPaid,
    required this.companyLogo,
    required this.customer,
    required this.products,
    required this.deliveryCharge,
    required this.otherCharge,
    required this.packageCharge,
    required this.serviceCharge,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      department: Department.fromJson(json['department'] ?? {}),
      billNo: json['bill_no'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      cashier: json['cashier'] ?? '',
      total: json['total'] ?? '',
      totalDiscount: json['total_discount'] ?? '',
      deliveryCharge: json['delivery_charge'] ?? '',
      otherCharge: json['other_charge'] ?? '',
      packageCharge: json['package_charge'] ?? '',
      serviceCharge: json['service_charge'] ?? '',
      totalPaid: json['total_paid'] ?? '',
      companyLogo: json['company_logo'] ?? '',
      customer: Customer.fromJson(json['customer'] ?? {}),
      products: (json['products'] as List<dynamic>? ?? [])
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class Department {
  int id;
  String name;
  String barcodeDepartmentName;
  String businessModel;
  String description;
  String departmentType;
  String code;
  String contact;
  String address;
  String email;
  String shopMsg;
  String thankMsg;
  String moreInfo;
  String latitude;
  String longitude;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String logo;
  String smsUrl;
  String voucherReceiptThanksMsg;
  String voucherNoticeMsg;
  String slogan;

  Department({
    required this.id,
    required this.name,
    required this.barcodeDepartmentName,
    required this.businessModel,
    required this.description,
    required this.departmentType,
    required this.code,
    required this.contact,
    required this.address,
    required this.email,
    required this.shopMsg,
    required this.thankMsg,
    required this.moreInfo,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.logo,
    required this.smsUrl,
    required this.voucherReceiptThanksMsg,
    required this.voucherNoticeMsg,
    required this.slogan,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      barcodeDepartmentName: json['barcode_department_name'] ?? '',
      businessModel: json['business_model'] ?? '',
      description: json['description'] ?? '',
      departmentType: json['department_type'] ?? '',
      code: json['code'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      shopMsg: json['shop_msg'] ?? '',
      thankMsg: json['thank_msg'] ?? '',
      moreInfo: json['more_info'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'] ?? '',
      logo: json['logo'] ?? '',
      smsUrl: json['smsUrl'] ?? '',
      voucherReceiptThanksMsg: json['voucher_receipt_thanks_msg'] ?? '',
      voucherNoticeMsg: json['voucher_notice_msg'] ?? '',
      slogan: json['slogan'] ?? '',
    );
  }
}

class Customer {
  String name;
  String code;

  Customer({required this.name, required this.code});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class Product {
  String unitName;
  String nameInTamil;
  int id;
  String code;
  String label;
  List<dynamic> attributes;
  List<dynamic> packageProducts;
  String unitPrice;
  String qty;
  String discount;
  String total;

  Product({
    required this.unitName,
    required this.nameInTamil,
    required this.id,
    required this.code,
    required this.label,
    required this.attributes,
    required this.packageProducts,
    required this.unitPrice,
    required this.qty,
    required this.discount,
    required this.total,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      unitName: json['unit_name'] ?? '',
      nameInTamil: json['name_in_tamil'] ?? '',
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      label: json['label'] ?? '',
      attributes: json['attributes'] ?? [],
      packageProducts: json['packageProducts'] ?? [],
      unitPrice: json['unit_price'] ?? '',
      qty: json['qty'] ?? '',
      discount: json['discount'] ?? '',
      total: json['total'] ?? '',
    );
  }
}
