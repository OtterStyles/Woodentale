using Godot;
using System;

public class ItemResource : Resource
{
    [Export()] public String Name;
    [Export()] public bool Stackable = false;
    [Export()] public int MaxStackSize = 1;

    public int Quantity = 0;

    enum ItemType
    {
        GENERIC,
        CONSUMABLE,
        QUEST,
        EQUIPMENT
    }
    [Export()] public Texture texture;
}
