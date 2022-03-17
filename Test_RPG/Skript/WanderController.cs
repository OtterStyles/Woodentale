using Godot;
using System;

public class WanderController : Node2D
{
    [Export()] public int wanderRange = 32;
    private Vector2 _startPosition = new Vector2();
    private Vector2 _targetPosition = new Vector2();
    
    public override void _Ready()
    {
        _startPosition = GlobalPosition;
        _targetPosition = GlobalPosition;

    }

    public void updateTargetPosition()
    {
        Random random = new Random();
        Vector2 targetVector = new Vector2(random.Next(-wanderRange, wanderRange),
                                            random.Next(-wanderRange, wanderRange));
        _targetPosition = _startPosition + targetVector;
    }
    
    public void onTimerTimeout()
    { 
        updateTargetPosition();   
    }

}
