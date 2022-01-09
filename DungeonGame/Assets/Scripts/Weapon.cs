using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : Collidable
{
    // Damage struct
    public int damagePoint = 1;
    public float pushForce = 2.0f;
    
    // Upgrade
    public int weaponLevel = 0;
    private SpriteRenderer spriteRender;

    
    // Swing
    private Animator anim;
    private float cooldown = 0.5f;
    private float lastSwing;
    
    protected override void Start()
    {
        base.Start();
        spriteRender = GetComponent<SpriteRenderer>();
        anim = GetComponent<Animator>();
    }

    protected override void Update()
    {
        base.Update();
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (Time.time - lastSwing > cooldown)
            {
                lastSwing = Time.time;
                Swing();
            }
        }
    }


    protected override void OnCollide(Collider2D coll)
    {
        if (coll.tag == "Fighter")
        {
            if (coll.name == "Player")
                return;
            
            // Create new Damage object an send it to the fighter
            Damage dmg = new Damage
            {
                damageAmount = damagePoint,
                origin = transform.position,
                pushForce = pushForce
            };
            coll.SendMessage("RecieveDamage",dmg);
        }
    }

    private void Swing()
    {
        anim.SetTrigger("Swing");
    }
    
}
