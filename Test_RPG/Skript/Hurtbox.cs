using Godot;
using System;

public class Hurtbox : Area2D
{
    [Export] public bool showHit = true;
    public PackedScene HitEffect = (PackedScene) ResourceLoader.Load("res://PreFab/Effects/HitEffect.tscn");


    public void _on_Hurtbox_area_entered(Area area)
    {
        if(showHit)
        {
            var effect = (Node2D) HitEffect.Instance();
            var main = GetTree().CurrentScene;
            main.AddChild(effect);
            effect.GlobalPosition = GlobalPosition;
        }
    }
    
}