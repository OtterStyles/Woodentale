using Godot;
using System;

public class WanderController : Node2D
{
    [Export()] public int WanderRange = 32;
    private Vector2 _startPosition = new Vector2();
    public Vector2 TargetPosition = new Vector2();
    private Timer _timer = new Timer();
    
    public override void _Ready()
    {
        _startPosition = GlobalPosition;
        TargetPosition = GlobalPosition;
        updateTargetPosition();
        _timer = GetNode<Timer>("Timer");

    }

    public void updateTargetPosition()
    {
        Random random = new Random();
        Vector2 targetVector = new Vector2(random.Next(-WanderRange, WanderRange),
                                            random.Next(-WanderRange, WanderRange));
        TargetPosition = _startPosition + targetVector;
    }

    public float getTimeLeft()
    {
        return _timer.TimeLeft;
    }

    public void startWanderTimer(float duration)
    {
        _timer.Start(duration);
    }

    public void onTimerTimeout()
    { 
        updateTargetPosition();
    }

}
