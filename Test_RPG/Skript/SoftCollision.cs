using Godot;

public class SoftCollision : Area2D
{
    public bool isColliding()
    {
        var areas = GetOverlappingAreas();
        return areas.Count > 0;
    }
    public Vector2 getPushVector()
    {
        var areas = GetOverlappingAreas();
        var pushVector = Vector2.Zero;
        if (isColliding())
        {
            Area2D area = (Area2D) areas[0];
            pushVector = area.GlobalPosition.DirectionTo(GlobalPosition).Normalized();
        }
        return pushVector;
    }
}
