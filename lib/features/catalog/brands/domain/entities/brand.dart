class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.businessId,
    this.isActive = true,
  });

  final int id;
  final String name;
  final int businessId;
  final bool isActive;

  Brand copyWith({String? name, bool? isActive}) => Brand(
        id: id,
        name: name ?? this.name,
        businessId: businessId,
        isActive: isActive ?? this.isActive,
      );
}
