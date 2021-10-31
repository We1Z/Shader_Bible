using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
// we have defined the [ExecuteInEditMode] over the class, This property will allow us to preview changes in edit mode
public class Wei_ReplacementController : MonoBehaviour
{
    // replacement shader
    public Shader m_replacementShader;
    private void OnEnable()
    {
        if(m_replacementShader != null)
        {
            // the camera will replace all the shaders in the scene 
            // whit the replacement one
            // the "render type" configuration must match in both shader
            GetComponent<Camera>().SetReplacementShader(m_replacementShader, "RenderType");
        }
    }

    private void OnDisable() 
    {
        // lets reset the default shader
    
        GetComponent<Camera>().ResetReplacementShader(); 
        
    }
}
