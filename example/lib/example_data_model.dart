class CarCategory {
  final String name;
  final String imagePath;
  final bool enabled;
  const CarCategory(
    this.name,
    this.imagePath, {
    this.enabled = true,
  });

  factory CarCategory.parent() =>
      const CarCategory('Car', 'assets/icons/car.svg');

  factory CarCategory.child1() =>
      const CarCategory('Ford', 'assets/icons/ford.svg');
  factory CarCategory.child2() =>
      const CarCategory('Honda', 'assets/icons/honda.svg');
  factory CarCategory.child3() =>
      const CarCategory('Lexus', 'assets/icons/lexus.svg');
  factory CarCategory.child4() =>
      const CarCategory('Maybach', 'assets/icons/maybach.svg');
  factory CarCategory.child5() =>
      const CarCategory('Maserati', 'assets/icons/maserati.svg');
  factory CarCategory.child6() =>
      const CarCategory('Peugeot', 'assets/icons/peugeot.svg');

  CarCategory enable() {
    return CarCategory(name, imagePath, enabled: true);
  }

  CarCategory disable() {
    return CarCategory(name, imagePath, enabled: false);
  }
}
