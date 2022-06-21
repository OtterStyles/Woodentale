using Godot;
using System;
using Object = System.Object;

public class BasicItemController : Node2D
{
    
    private void _on_Area2D_body_entered(KinematicBody2D body)
    {
        if (body.IsInGroup("Player"))
        {
            changeStats();
        }
    }

    public virtual void changeStats()
    {
        QueueFree();
    }
}
