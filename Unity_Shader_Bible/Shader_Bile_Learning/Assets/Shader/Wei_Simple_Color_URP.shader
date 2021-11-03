Shader "Unlit/Wei_Simple_Color_URP"
{
    Properties
    {
        //Formats: PropertiesName ("display name", type) = default value

        // Texture Properties
        _MainTex ("Texture", 2D) = "white" {}
        //_Reflection ("Reflection", Cube) = "black" {}
        //_3DTexture ("3D texture", 3D) = "white" {}

        // Number and slider properties
        //_Specular ("Specular", Range(0,1)) = 0.5
        //_Factor ("Color Factor", float) = 0.3
        //_Cid ("Color ID", int) = 1

        // Color and Vector Properties
        //_Color ("Tint", Color) = (1,1,1,1)
        //_VPos ("Vectex Position", Vector) = (0,0,0,1)







    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
            "RenderPipeline" = "UniversalRenderPipeline"
        }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog
            //#pragma multi_compile
            //#pragma shader_feature

            #include "UnityCG.cginc"
            #include "Package/com.unity.render.pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "HLSLSupport.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col * _Color;
            }
            ENDHLSL
        }
    }
}
