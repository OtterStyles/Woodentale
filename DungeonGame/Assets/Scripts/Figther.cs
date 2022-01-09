using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Figther : MonoBehaviour
{
    //Public field
    public int hitpoint;
    public int maxHitpoint = 10;
    public float pushRecoverySpeed = 2.0f;
    
    // Immunity
    protected float immuneTime = 1.0f;
    protected float lastImmune;
    
    //Push
    protected Vector3 pushDirection;
    
    // All fighters can RecieveDamaege / Die

    protected virtual void RecieveDamage(Damage dmg)
    {
        if (Time.time - lastImmune > immuneTime)
        {
            lastImmune = Time.time;
            hitpoint -= dmg.damageAmount;
            pushDirection = (transform.position - dmg.origin).normalized * dmg.pushForce;
            
            GameManager.instance.ShowText(dmg.damageAmount.ToString(), 15, Color.red, transform.position, Vector3.zero, 0.5f);
            
            if (hitpoint <= 0)
            {
                hitpoint = 0;
                Death();
            }
            
        }
    }

    protected virtual void Death()
    {
        
    }
}
