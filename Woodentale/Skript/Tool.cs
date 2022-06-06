using Godot;
using System;
using Woodentale.Skript.Manager;

public class Tool : Node2D
{
    [Export()] public int hitpoints = 1;
    [Export()] public Materials material = Materials.Wood;
    [Export()] public int level = 0;
    [Export()] public int maxLevel = 0;
    [Export()] public toolIDs toolID = toolIDs.Axe;
    private Sprite sprite = null;
    public Manager manager = null;

    public override void _Ready()
    {
        manager = GetNode<Manager>("/root/Manager");
        manager.Connect("toolLevelUpgrade", this, "toolLevelUpgrade");
        sprite = GetNode<Sprite>("Sprite");
        sprite.Hframes = 10;
        sprite.Frame = level;
    }

    private void toolLevelUpgrade(toolIDs id)
    {
        if (id == toolID && level < maxLevel)
        {
            level++;
            sprite.Frame = level;
        }
    }
}