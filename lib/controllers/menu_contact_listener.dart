import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart';

class MenuContactListener extends ContactListener {
  @override
  void beginContact(Contact contact) {
    var bodyA = contact.bodyA;
    var bodyB = contact.bodyB;
    Vector2 collisionDirection = (bodyB.position - bodyA.position).normalized();

    Vector2 impulse = collisionDirection * 300.0;

    (contact.bodyB.userData as MenuItemBox2D).isCollided = true;
    bodyB.applyLinearImpulse(impulse, point: bodyB.worldCenter);
    Future<void>.delayed(Durations.long1).then((_) {
      (contact.bodyB.userData as MenuItemBox2D).isCollided = false;
      (contact.bodyB.userData as MenuItemBox2D).reposition();
    });
  }

  @override
  void endContact(Contact contact) {}
}
