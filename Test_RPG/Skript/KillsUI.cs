using Godot;

namespace Test_RPG.Skript
{
   public class KillsUI : Control
   {
      public int kills = 0;
      private Label _killsRect = null;
      private PlayerStats _playerStats = null;
    
       
      public override void _Ready()
      {
         _playerStats = GetNode<PlayerStats>("/root/PlayerStats");
         _killsRect = GetNode<Label>("Kills");
         _playerStats.Connect("killsChanged", this, "killsChanged");
         kills = _playerStats.Kills;
         _killsRect.Text = "Kills: " + kills;
      }

      private void killsChanged(int value)
      {
         kills = value;
         _killsRect.Text = "Kills: " + kills;
      }
   }
}
