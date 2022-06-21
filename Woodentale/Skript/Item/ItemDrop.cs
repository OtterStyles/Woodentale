using Godot;
using System;

public class ItemDrop : Node2D
{
    public ItemResource itemResource = null;
    Sprite sprite = null;

    public override void _Ready()
    {
        sprite = GetNode<Sprite>("Sprite");
    }
    public void onCreate(){
        sprite.Texture = itemResource.texture;
    }


    public void _on_Area2D_area_entered(Area2D area)
    {
        QueueFree();
    }
}
