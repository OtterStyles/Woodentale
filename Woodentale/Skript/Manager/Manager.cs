using Godot;
using System;
using Woodentale.Skript.Manager;

public class Manager : Node
{
    [Signal]
    delegate void toolLevelUpgrade(toolIDs id);
}