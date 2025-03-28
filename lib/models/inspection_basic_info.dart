class InspectionBasicInfo {
  final String pdfPath;
  final String billTo;
  final String location;
  final String billToLn2;
  final String locationLn2;
  final String attn;
  final String street;
  final String streetLn2;
  final String street2;
  final String street2Ln2;
  final String cityState;
  final String cityStateLn2;
  final String cityState2;
  final String cityState2Ln2;
  final String contact;
  final String date;
  final String phone;
  final String inspector;
  final String email;
  final String inspFreq;
  final String inspNum;

  InspectionBasicInfo({
    required this.pdfPath,
    required this.billTo,
    required this.location,
    required this.billToLn2,
    required this.locationLn2,
    required this.attn,
    required this.street,
    required this.streetLn2,
    required this.street2,
    required this.street2Ln2,
    required this.cityState,
    required this.cityStateLn2,
    required this.cityState2,
    required this.cityState2Ln2,
    required this.contact,
    required this.date,
    required this.phone,
    required this.inspector,
    required this.email,
    required this.inspFreq,
    required this.inspNum,
  });

  factory InspectionBasicInfo.fromJson(Map<String, dynamic> json) {
    return InspectionBasicInfo(
      pdfPath: json['pdf_path']?.toString() ?? 'N/A',
      billTo: json['BILL TO']?.toString() ?? '',
      location: json['LOCATION']?.toString() ?? '',
      billToLn2: json['BILL TO LN2']?.toString() ?? '',
      locationLn2: json['LOCATION LN2']?.toString() ?? '',
      attn: json['ATTN']?.toString() ?? '',
      street: json['STREET']?.toString() ?? '',
      streetLn2: json['STREET LN2']?.toString() ?? '',
      street2: json['STREET_2']?.toString() ?? '',
      street2Ln2: json['STREET_2 LN 2']?.toString() ?? '',
      cityState: json['CITY  STATE']?.toString() ?? '',
      cityStateLn2: json['CITY STATE LN 2']?.toString() ?? '',
      cityState2: json['CITY  STATE_2']?.toString() ?? '',
      cityState2Ln2: json['CITY STATE_2 LN 2']?.toString() ?? '',
      contact: json['CONTACT']?.toString() ?? '',
      date: json['DATE']?.toString() ?? 'N/A',
      phone: json['PHONE']?.toString() ?? '',
      inspector: json['INSPECTOR']?.toString() ?? 'N/A',
      email: json['EMAIL']?.toString() ?? '',
      inspFreq: json['INSP_FREQ']?.toString() ?? '',
      inspNum: json['INSP_#']?.toString() ?? '',
    );
  }
}