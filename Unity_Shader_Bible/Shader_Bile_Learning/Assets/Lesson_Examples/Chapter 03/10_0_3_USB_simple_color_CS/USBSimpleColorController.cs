using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class USBSimpleColorController : MonoBehaviour
{
    public ComputeShader m_shader;
    public RenderTexture m_mainTex;
    int m_texSize = 256;
    Renderer m_rend;    

    // Start is called before the first frame update
    void Start()
    {
        // primero creamos la textura
        m_mainTex = new RenderTexture(256, 256, 0, RenderTextureFormat.ARGB32);
        m_mainTex.enableRandomWrite = true;
        m_mainTex.Create();

        // luego obtenemos el renderer que ha sido asignado al mesh.
        m_rend = GetComponent<Renderer>();
        m_rend.enabled = true;

        // luego asignamos 
        m_shader.SetTexture(0, "Result", m_mainTex);
        m_shader.SetFloat("texSize", m_mainTex.width);
        m_rend.material.SetTexture("_MainTex", m_mainTex);

        // luego hacemos el dispatch
        m_shader.Dispatch(0, 265/8, 256/8, 1);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
