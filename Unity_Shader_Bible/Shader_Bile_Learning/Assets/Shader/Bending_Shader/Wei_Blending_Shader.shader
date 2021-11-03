Shader "Unlit/Wei_Blending_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        //adding blending mode using dependency in unity 
        [Enum(UnityEngine.Rendering.Blendmode)] _SrcBlend ("Source Factor", Float) = 1
        [Enum(UnityEngine.Rendering.Blendmode)] _DstBlend ("Destination Factor", Float) = 1
        

    }
    SubShader
    {
        // if we want blending in shader, then we need to change "Queue" and "Render Type" both to "Transparent"
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        // syntax is << Blend [Source Factor] [Destination Factor]
        Blend [_SrcBlend] [_DstBlend]
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
