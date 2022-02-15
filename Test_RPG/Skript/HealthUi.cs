using Godot;
using System;
using Vector2 = System.Numerics.Vector2;

public class HealthUi : Control
{
   public int maxHearts = 4;
   public int hearts = 4;
   private TextureRect _fullHearts = null;
   private TextureRect _emptyHearts = null;
   private PlayerStats _playerStats = null;

   
   public override void _Ready()
   {
      _playerStats = GetNode<PlayerStats>("/root/PlayerStats");
      _fullHearts = GetNode<TextureRect>("./HeartUIFull");
      _emptyHearts = GetNode<TextureRect>("./HeartUIEmpty");
      MaxHearts = _playerStats.MaxHealth;
      Hearts = _playerStats.Health;
      _playerStats.Connect("healthChanged", this, "healthChanged");
      _playerStats.Connect("maxHealthChanged", this, "maxHealthChanged");
   }
   public int Hearts
   {
      get => hearts;
      set
      {
         hearts = Mathf.Clamp(value, 0, MaxHearts);
         GD.Print(hearts);
         if (_fullHearts != null)
         {
            _fullHearts.RectSize = new Godot.Vector2(hearts * 15, 10);
         }
      }
   }

   public int MaxHearts
   {
      get => maxHearts;
      set
      {
         maxHearts = Mathf.Max(value, 1);
         if (_emptyHearts != null)
         {
            _emptyHearts.RectSize = new Godot.Vector2(hearts * 15, 10);
         }
      }
   }


   private void healthChanged(int value)
   {
      Hearts = value;
   }
   private void maxHealthChanged(int value)
   {
      MaxHearts = value;
   }
   
}
