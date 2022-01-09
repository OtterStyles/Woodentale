using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;

    private void Awake()
    {
        if (GameManager.instance != null)
        {
            Destroy(gameObject);
            return;
        }
        instance = this;
        SceneManager.sceneLoaded += LoadState;
        DontDestroyOnLoad(gameObject);
    }
    
    //Resources
    public List<Sprite> playerSprites;
    public List<Sprite> weaponSprites;
    public List<int> weaponPrices;
    public List<int> xPTable;
    
    // References
    public player player;
    //public weapon weapon
    public FloatingTextManager floatingTextManager;
    //Logig
    public int pesos;
    public int exceprience;

    public void ShowText(string msg,int fontSize,Color color, Vector3 position, Vector3 motion, float duration)
    {
        floatingTextManager.Show(msg,fontSize,color,position,motion,duration);
    }
    
    // Save state
    /*
     * INT preferedSkin
     * INT pesos
     * INT experience
     * Int weaponLevel
     */
    public void SaveState(Scene scene, LoadSceneMode mode )
    {
        string s = "";
        s += "0" + "|";
        s += pesos.ToString() + "|";
        s += exceprience.ToString() + "|";
        s += "0";
        
        PlayerPrefs.SetString("SaveState", s);
        Debug.Log("Saved State");
    }

    public void LoadState(Scene scene, LoadSceneMode mode)
    {
        if (!PlayerPrefs.HasKey("SaveState"))
        {
            return;
        }
        string[] data = PlayerPrefs.GetString("SaveState").Split('|');
        
        // Change player skin
        pesos = int.Parse(data[1]);
        exceprience = int.Parse(data[2]);
        // Change weaponLevel
        Debug.Log("Loaded State");

    }
}
