class Warehouse {
  const Warehouse({
    required this.id,
    required this.name,
    required this.outletId,
    this.isDefault = false,
    this.isActive = true,
  });

  final int id;
  final String name;
  final int outletId;
  final bool isDefault;
  final bool isActive;

  Warehouse copyWith({String? name, bool? isDefault, bool? isActive}) => Warehouse(
        id: id,
        name: name ?? this.name,
        outletId: outletId,
        isDefault: isDefault ?? this.isDefault,
        isActive: isActive ?? this.isActive,
      );
}
