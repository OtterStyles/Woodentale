using Godot;
using System;

public class CameraMain : Camera2D
{
    public Position2D _topLeft = null;
    public Position2D _bottomRight = null;
    public override void _Ready()
    {
        _topLeft = GetNode<Position2D>("Limits/TopLeft");
        _bottomRight = GetNode<Position2D>("Limits/BottomRight");
        LimitTop = (int) _topLeft.Position.y;
        LimitLeft = (int) _topLeft.Position.x;
        LimitBottom = (int) _bottomRight.Position.y;
        LimitRight = (int) _bottomRight.Position.x;
    }
}
