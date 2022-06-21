using Godot;
using System;

public class PlayerDefaults : Resource
{
    [Export()] public int MAX_SPEED = 80;
    [Export()] public int MAX_SPEED_SPRINT = 160;	
    [Export()] public int ACCELERATION = 500;
    [Export()] public int FRICTION = 600;
}