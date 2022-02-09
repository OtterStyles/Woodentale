using Godot;
using System;

public class Bat : KinematicBody2D
{
    Vector2 knockback = Vector2.Zero;

    public override void _PhysicsProcess(float delta)
    {
        knockback = knockback.MoveToward(Vector2.Zero, 200 * delta);
        knockback = MoveAndSlide(knockback);
    }

    public void onHurtboxAreaEntered(Sword area)
    {
        knockback = area.knockback_vector * 140;
    }
}
