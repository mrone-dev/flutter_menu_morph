import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart';

class MenuContactListener extends ContactListener {
  @override
  void beginContact(Contact contact) {
    var bodyA = contact.bodyA;
    var bodyB = contact.bodyB;
    var itemA = (bodyA.userData as MenuItemBox2D);
    var itemB = (bodyB.userData as MenuItemBox2D);
    var isPrioritizedA = itemA.isPrioritized;
    var isPrioritizedB = itemB.isPrioritized;
    if (isPrioritizedA && !isPrioritizedB) {
      itemB
          .collidedWithTheOther((bodyB.position - bodyA.position).normalized());
    } else if (isPrioritizedB && !isPrioritizedA) {
      itemA
          .collidedWithTheOther((bodyA.position - bodyB.position).normalized());
    } else {
      itemB
          .collidedWithTheOther((bodyB.position - bodyA.position).normalized());
      itemA
          .collidedWithTheOther((bodyA.position - bodyB.position).normalized());
    }
  }

  @override
  void endContact(Contact contact) {}
}
