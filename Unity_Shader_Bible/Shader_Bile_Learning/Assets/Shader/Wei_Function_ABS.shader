﻿Shader "Unlit/Wei_Function_ABS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        // lets add a property to later rotate the UV
        _Rotation("Rotation", Range(0,360)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
            float _Rotation;

          


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


              void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
            {
                Rotation = Rotation * (UNITY_PI/180.0f);
                UV -= Center;
                float s = sin(Rotation);
                float c = cos(Rotation);
                float2x2 rMatrix = float2x2(c, -s, s, c);
                rMatrix *= 0.5;
                rMatrix += 0.5;
                rMatrix = rMatrix * 2 - 1;
                UV.xy = mul(UV.yx, rMatrix);
                UV += Center;
                Out = UV;

            }
            
        
            
            
            fixed4 frag (v2f i) : SV_Target
            {
                //lets calculate the absolute value of U
                float u = abs(i.uv.x - 0.5);

                // lets calculate the absolute value of v
                float v = abs(i.uv.y - 0.5);


                // we linke the roation property
                float rotation = _Rotation;
            
                // we center the rotation pivot
                float center = 0.5;

                // lets generate new UV coordinates for the textures
                float2 uv = 0;

                Unity_Rotate_Degrees_float(float2(u,v), center, rotation, uv);

                fixed col = tex2D(_MainTex, uv); 
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
